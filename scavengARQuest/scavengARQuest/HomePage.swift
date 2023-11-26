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
    @State private var isOnQuestTab = false
    private let nFields = Mirror(reflecting: Quest.self).children.count
    private let serverUrl = "https://3.142.74.134"
    
    func getQuests() async throws -> [Quest] {
        let userId = UserDefaults.standard.integer(forKey: "userID")
        let endpoint = serverUrl + "/users/\(userId)/quests/"
        
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
            NavigationStack {
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
                                ActiveQuestCard(quest: quest)
                            }
                            Text("Trending")
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical)
                            .padding(.trailing, 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: [GridItem()]) {
                                    ForEach(inactive_quests) { quest in
                                        InactiveQuestCard(quest: quest)
                                    }
                                }
                            }
                    }
                    .task {
                        do {
                            quests = try await getQuests()
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

