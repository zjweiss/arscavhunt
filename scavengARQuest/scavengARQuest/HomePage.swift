//
//  HomePage.swift
//  ScavengARQuest
//
//  Created by Abbie Tooman on 10/30/23.
//

import SwiftUI

struct Quest: Codable, Identifiable {
    let quest_id: Int
    let quest_name: String
    let quest_thumbnail: String
    let quest_description: String
    let quest_rating: String
    let estimated_time: String
    let incomplete: Int
    let complete: Int
    let quest_status: String
    
    var id: Int { return quest_id }
}

enum RequestError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}

struct HomePage: View {
    @State private var searchText = ""
    @State private var quests: [Quest] = []
    @State private var active_quests: [Quest] = []
    @State private var inactive_quests: [Quest] = []
    @State private var isAcceptingQuest = false
    @State private var questAcceptance = Quest(quest_id: -1, quest_name: "", quest_thumbnail: "", quest_description: "", quest_rating: "", estimated_time: "", incomplete: -1, complete: -1, quest_status: "")
    private let nFields = Mirror(reflecting: Quest.self).children.count

    private let serverUrl = "https://3.142.74.134"
    // @State private var filteredQuests: [Quest] = []

    // Function to filter quests based on the search text
//    private func filterQuests() {
//        filteredQuests = quests.filter { quest in
//            let questNameLowercased = quest.quest_name.lowercased()
//            let searchTextLowercased = searchText.lowercased()
//            let contains = questNameLowercased.contains(searchTextLowercased)
//
//            print("Quest Name: \(questNameLowercased), Search Text: \(searchTextLowercased), Contains: \(contains)")
//
//            return contains
//        }
//    }
    
    @ViewBuilder
    func ActiveQuestButton(quest: Quest) -> some View {
        ZStack{
            Button {
                //do something
                Task{
                    print("in active quest button")
                }
            } label: {
                VStack {
                    if let imageUrl = URL(string: quest.quest_thumbnail) {
                        AsyncImage(url: imageUrl){
                            $0.resizable()
                                .scaledToFit()
                                .foregroundStyle(.tint)
                                .cornerRadius(5.0)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300, height: 200)
                    }
                    Spacer()
                    Text(quest.quest_name)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    
    @ViewBuilder
    func InactiveQuestButton(quest: Quest) -> some View {
        NavigationLink(destination: QuestDetailPage(quest: quest)){
            ZStack{
                Button {
                    //do something
                    Task{
                        isAcceptingQuest.toggle()
                        questAcceptance = quest
                        print(String(isAcceptingQuest))
                        print("in inactive quest button")
                    }
                } label: {
                    VStack {
                        if let imageUrl = URL(string: quest.quest_thumbnail) {
                            AsyncImage(url: imageUrl){
                                $0.resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.tint)
                                    .cornerRadius(5.0)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 300, height: 200)
                        }
                        Spacer()
                        Text(quest.quest_name)
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .id(quest.id)
    }
    
    
    func getQuests() async throws -> [Quest] {
        let user_id = "1"
        let endpoint = serverUrl + "/users/\(user_id)/quests/"
        
        guard let url = URL(string: endpoint) else {
            throw RequestError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw RequestError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            
            struct QuestResponse: Codable {
                let data: [Quest]
            }
            
            // Decode the JSON data into the QuestResponse struct
            let questResponse = try decoder.decode(QuestResponse.self, from: data)
            print("This is the quest response data", questResponse)
            
            // Access the array of quests
            let quests_all = questResponse.data
            
            return quests_all
        } catch RequestError.invalidData {
            print("Invalid Data")
            throw RequestError.invalidData
        } catch RequestError.invalidResponse {
            print("Invalid Response")
            throw RequestError.invalidResponse
        } catch RequestError.invalidUrl {
            print("Invalid URL")
            throw RequestError.invalidUrl
        } catch {
            print("Unexpected API error: \(error)")
            throw error
        }
    }
    
    
    var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        HStack {
                            Text("ScavangAR")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "app.gift")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                            Image(systemName: "bell")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                        }
                        Text("Ann Arbor, MI")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Search for quest...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        //if searchText.isEmpty {
                            Text("Active")
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical)
                            //  Active Quests
                            ForEach(active_quests) { quest in
                                ActiveQuestButton(quest: quest)
                            }
                            Text("Trending")
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical)
                            .padding(.trailing, 20)
                            ForEach(inactive_quests) { quest in
                                InactiveQuestButton(quest: quest)
                            }
                    }
                    .task {
                        do {
                            print("this is the response")
                            quests = try await getQuests()
                            print("this is the response ", quests)
                            // sort quests into active and inactive
                            active_quests = quests.filter { $0.quest_status == "active" }
                            inactive_quests = quests.filter { $0.quest_status == "inactive" }
                            
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
                    .padding()
                }
            }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

