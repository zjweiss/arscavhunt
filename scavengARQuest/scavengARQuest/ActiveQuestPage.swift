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
    let ar_enabled: Bool
    let distance_threshold: String
    let status: String
    let points: String
    let tags: String
}

struct ActiveQuestPage: View {
    // This needs to be passed in from the Home Page card, so
    // that way I can make a request to the server.
    var quest : Quest
    
    @State private var userId: Int = UserDefaults.standard.integer(forKey: "userID")
    @State private var response: ActiveQuestLocationsResponseWrapper?
    @State private  var questId: Int = -1
    @State private  var questName: String = ""
    @State private  var incomplete: Int = -1
    @State private var complete: Int = -1
    @State private var inLocationDetails: Bool = false
    @State private var locationState: Location = Location(quest_id: -1, location_id: -1, name: "", latitude: "", longitude: "", description: "", thumbnail: "", ar_enabled: false, distance_threshold: "", status: "", points: "", tags: "")
    
    func getActiveQuestLocations() async throws -> ActiveQuestLocationsResponseWrapper {
        questId = quest.quest_id
        questName = quest.quest_name
        incomplete = quest.incomplete
        complete = quest.complete
        
        let userID = UserDefaults.standard.integer(forKey: "userID")
        let endpoint = "https://3.142.74.134/users/" + String(userID) + "/quests/" + String(questId) + "/"
        print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            throw RequestError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("IR")
            throw RequestError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            //decoder.keyDecodingStrategy = .useDefaultKeys
            return try decoder.decode(ActiveQuestLocationsResponseWrapper.self, from: data)
        } catch {
            throw RequestError.invalidData
        }
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // QUEST NAME
                    Text(questName)
                        .font(.system(size: 30))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                   
                    Spacer()
                    
                    // HEADER
                    HStack(spacing: 75) {
                        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                            Text(String(complete))
                                .font(.system(size: 28))
                                .fontWeight(.semibold)
                            
                            Text("Completed")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray) // Set the text color to gray
                        }
                        
                        Divider()
                        
                        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                            Text(String(incomplete))
                                .font(.system(size: 28))
                                .fontWeight(.semibold)
                            
                            Text("To Go")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray) // Set the text color to gray
                        }
                    }
                    .padding(.vertical, 25)
                    
                    // LIST OF SUBQUESTS / LOCATIONS
                    if let unwrapped = response {
                        ForEach(unwrapped.data.indices, id: \.self) { index in
                            let location = unwrapped.data[index]
                            Button {
                                locationState = location
                                inLocationDetails.toggle()
                            } label: {
                                ActiveQuestLocationCard(data: location)
                            }
                            .sheet(isPresented: $inLocationDetails){
                                LocationDetails(locationDetailStore: locationState)
                            }
                        }
                    } else {
                        Text("Loading...")
                            .foregroundColor(Color.gray)
                    }
                    
                }
                .task {
                    do {
                        response = try await getActiveQuestLocations()
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
