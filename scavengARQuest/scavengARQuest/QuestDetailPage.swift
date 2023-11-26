//
//  QuestDetailPage.swift
//  ScavengARQuest
//
//  Created by Abbie Tooman on 10/30/23.
//

import SwiftUI

struct QuestDetailPage: View {
    
    //TODO remove this
    let questID: Int
    @State private var teamId = ""
    @State private var showAlert = false
    @Binding var returnBool: Bool
    let serverUrl = "https://3.142.74.134"
    private let store = ScavengarStore.shared

    
    func submitQuestAcceptance(userID: Int, questID: Int) async {

        //format of api endpoint: BASE/users/<user_id>/quests/<quest_id>/accept
        let urlString = serverUrl+"/users/" + String(userID) + "/quests/" + String(questID) + "/accept/"
        print(urlString)
        guard let apiUrl = URL(string: urlString ) else {
            print("login: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                print("accept quest: \(HTTPURLResponse.localizedString(forStatusCode: http.statusCode))")
                return
            }
        } catch {
            print("login: NETWORKING ERROR")
        }
        returnBool.toggle()
        return
    }


    @ViewBuilder
    @MainActor
    func AcceptQuest(teamAccept: Bool, teamId: String) -> some View {
            ZStack{
                Button {
                    //do something
                    Task{
                        if store.username == "" { // no one is logged in, so show alert message
                            showAlert.toggle()
                        } else {
                            if (teamAccept == true){
                                // do multi user quest acceptance stuff
                                // to be implemented in MVP
                            } else {
                                // do single user quest acceptance
                                await submitQuestAcceptance(userID: store.userID, questID: questID)
                            }
                        }
                    }
                } label: {
                    Text("Accept Quest")
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(Color(red: 23 / 255.0, green: 37 / 255.0, blue: 84 / 255.0))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .frame(width: 128, height: 28)
                }
                .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Not logged in"),
                            message: Text("You are not currently logged in, and can't accept any quests.")
                        )
                    }
            }
        }

    
    
    var body: some View {
        let quest: Quest = store.questDict[questID] ?? Quest(quest_id: 0, quest_name: "", quest_thumbnail: "", quest_description: "", quest_rating: "", estimated_time: "", incomplete: -1, complete: -1, quest_status: "active")
        NavigationView{
            VStack{
                HStack{
                    Text(quest.quest_name)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.black)
                        .padding()
                    Image(systemName: "app.gift")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Image(systemName: "bell")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                }
                if let imageUrl = URL(string: quest.quest_thumbnail) {
                    AsyncImage(url: imageUrl){
                        $0.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 392, height: 174)
                    .cornerRadius(5.0)
                }
                HStack{
                    VStack{
                        // try and get the time, or set it to 1 hour default
                        let timeEstimate: String = quest.estimated_time
                        let timeString = String(Int(floor((Double(timeEstimate) ?? 3600.00) / 60))) + " Minutes"
                        Text(timeString)
                            .font(.title2)
                        Text("Total Time")
                            .font(.title3)
                    }
                    Divider()
                        .background(Color.gray)
                        .frame(height: 70)
                        .padding(.horizontal, 30)
                    VStack{
                        // We know that the total quests = incomplete quests
                        // because the only way you can be on this screen is if you
                        // haven't done any quests
                        Text(String(quest.incomplete))
                            .font(.title2)
                        Text("Total Quests")
                            .font(.title3)
                    }
                }
                .padding(.bottom, 5)
                Text("What Awaits?")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                Text(quest.quest_description)
                    .font(.body) // Set the font size
                    .foregroundColor(Color.gray) // Set the text color
                    .lineSpacing(8)
                    .padding(.bottom, 30)
                HStack{
                    VStack{
                        Text("JOIN A TEAM.")
                        TextField("Enter Team Id...", text: $teamId)
                            .frame(width: 132, height: 32)
                            .background(Color(red: 235 / 255.0, green: 232 / 255.0, blue: 232 / 255.0))
                        AcceptQuest(teamAccept: true, teamId: teamId)
                    }
                    VStack {
                        HStack{
                            Divider()
                            .background(Color.gray)
                            .frame(height: 30)
                        }
                        Text("OR")
                        HStack{
                            Divider()
                            .background(Color.gray)
                            .frame(height: 30)
                        }
                    }
                    .padding(.horizontal)
                    VStack{
                        Text("GO SOLO.")
                        // teamID isn't used unless teamAccept is true
                        AcceptQuest(teamAccept: false, teamId: teamId)
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

/*
struct QuestDetailPage_Preview: PreviewProvider {
    static var previews: some View {
        QuestDetailPage()
    }
}
*/
