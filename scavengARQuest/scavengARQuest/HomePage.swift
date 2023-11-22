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
    private let store = ScavengarStore.shared
    @State private var searchText = ""
    @State private var active_quests: [Quest] = []
    @State private var inactive_quests: [Quest] = []
    @State private var isAcceptingQuest = false
    @State private var isOnQuestTab = false
    private let nFields = Mirror(reflecting: Quest.self).children.count
    private let serverUrl = "https://3.142.74.134"
    
    
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
                                ActiveQuestCard(questId: quest.quest_id)
                            }
                            Text("Trending")
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical)
                            .padding(.trailing, 20)
                            ForEach(inactive_quests) { quest in
                                InactiveQuestCard(questId: quest.quest_id)
                            }
                    }
                    .task {
                        do {
                            try await store.getQuests()
                            active_quests = store.quests.filter { $0.quest_status == "active" }
                            inactive_quests = store.quests.filter { $0.quest_status == "inactive" }
                            
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

