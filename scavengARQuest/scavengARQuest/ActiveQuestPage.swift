//
//  ActiveQuestPage.swift
//  ScavengARQuest
//
//  Created by Janice Liu on 11/1/23.
//

import SwiftUI

struct ActiveQuestLocationsResponseWrapper: Codable {
    let data: [Location]
}

struct Location: Codable {
    let quest_id: Int
    let location_id: Int
    let name: String
    let latitude: String
    let longitude: String
    let description: String
    let thumbnail: String
    let ar_file: String // "" if there is no ar_file
    let ar_displacement: Double // 0 if there is no ar_file
    let ar_unwrap: Bool // false if there is no ar_file
    let distance_threshold: String
    var status: String
    let points: String
    let tags: String
    let team_code: String
}

struct TeamateResponseWrapper: Codable {
    let data: [Teamate]
}

struct Teamate: Codable, Identifiable {
    let id: Int
    let first_name: String
    let last_name: String
    let username: String
    let avatar_url: String

}

struct ActiveQuestPage: View {
    private let store = ScavengarStore.shared
    @State var questId: Int
    @State private var inLocationDetails: Bool = false
    @State private var locationState: Location = Location(quest_id: -1, location_id: -1, name: "", latitude: "", longitude: "", description: "", thumbnail: "", ar_file: "", distance_threshold: "", status: "", points: "", tags: "", team_code: "")
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Swipe down to refesh!")
                        .font(.system(size: 15))
                        .foregroundColor(Color.gray)
                    Text("Team Code: \(store.questTeamDict[questId] ?? "ERROR_CODE")")
                        .font(.system(size: 20))
                        .foregroundColor(Color.gray)
                    
                    // Only display avatars if there are more than 1 person on team.
                    if let teamates = store.questTeamateDict[questId] {
                        if (teamates.count > 1){
                            HStack{
                                ForEach(teamates, id: \.id) { member in
                                    if let imageUrl = URL(string: member.avatar_url) {
                                        AsyncImage(url: imageUrl){
                                            $0.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: .infinity)
                                                .clipShape(Circle())
                                                .frame(width: 30, height: 30)
                                                .foregroundStyle(.tint)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        
                                    }

                                }
                            }
                        }
                    }
                    
                    // QUEST NAME
                    if let questStruct = store.questDict[questId] {
                        Text(questStruct.quest_name)
                            .font(.system(size: 30))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        
                        Spacer()
                        
                        // HEADER
                        HStack(spacing: 75) {
                            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                                Text(String(questStruct.complete))
                                    .font(.system(size: 28))
                                    .fontWeight(.semibold)
                                
                                Text("Completed")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.gray) // Set the text color to gray
                            }
                            
                            Divider()
                            
                            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                                Text(String(questStruct.incomplete))
                                    .font(.system(size: 28))
                                    .fontWeight(.semibold)
                                
                                Text("To Go")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.gray) // Set the text color to gray
                            }
                        }
                        .padding(.vertical, 25)
                    }
                    // LIST OF SUBQUESTS / LOCATIONS
                    if let unwrapped = store.questLocationDict[questId] {
                        ForEach(unwrapped.indices, id: \.self) { index in
                            let location = unwrapped[index]
                            ActiveQuestLocationCard(locationID: location)
                        }
                    } else {
                        Text("Loading...")
                            .foregroundColor(Color.gray)
                    }
                    
                }
            }
            .refreshable{
                do {
                    print(0)
                    try await store.getQuests()
                    print(1)
                    try await store.getActiveQuestLocations(questID: questId)
                    print(2)
                    try await store.getOtherTeamates(questID: questId)
                    print(3)
                } catch RequestError.invalidData {
                    print("Invalid Data")
                } catch RequestError.invalidResponse {
                    print("Invalid Response")
                } catch RequestError.invalidUrl {
                    print("Invalid URL")
                } catch {
                    print("Unexpected API error")
                }
            }
        }
        .onAppear(perform: {
            Task{
                do {
                    try await store.getQuests()
                    try await store.getActiveQuestLocations(questID: questId)
                    try await store.getOtherTeamates(questID: questId)
                } catch RequestError.invalidData {
                    print("Invalid Data")
                } catch RequestError.invalidResponse {
                    print("Invalid Response")
                } catch RequestError.invalidUrl {
                    print("Invalid URL")
                } catch {
                    print("Unexpected API error")
                }
            }
        })
        .padding()
    }
}

/*
struct ActiveQuestPage_Preview: PreviewProvider {
    static var previews: some View {
        @State var questId: Int = 1
        @State var questName: String = "Campus Study Spots"
        @State var complete: Int = 1
        @State var incomplete: Int = 6
        
        ActiveQuestPage(
            questId: $questId,
            questName: $questName,
            incomplete: $incomplete,
            complete: $complete
        )
    }
}
*/
