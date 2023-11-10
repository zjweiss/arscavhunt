//
//  QuestList.swift
//  ScavengARQuest
//
//  Created by Abbie Tooman on 11/7/23.
//

import Observation
import Foundation

import Observation

@Observable
final class QuestList {
    static let shared = QuestList() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    private(set) var quests = [Quest]()
    private let nFields = Mirror(reflecting: Quest.self).children.count

    private let serverUrl = "https://3.142.74.134/"
    
    func getQuests() {
        let user_id = "1"
        guard let apiUrl = URL(string: "\(serverUrl)/users/\(user_id)/quests") else {
            print("getQuests: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("getQuests: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getQuests: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getQuests: failed JSON deserialization")
                return
            }
            let questsReceived = jsonObj["data"] as? [[String?]] ?? []
            
            DispatchQueue.main.async {
                self.quests = [Quest]()
                for questEntry in questsReceived {
                    if questEntry.count == self.nFields {
                        let quest = Quest(
                                quest_id: questEntry[0] ?? "none",
                                name: questEntry[1] ?? "none",
                                quest_status: questEntry[2] ?? "none",
                                thumbnail: questEntry[3] ?? "none",
                                description: questEntry[4] ?? "none",
                                rating: questEntry[5] ?? "none",
                                estimated_time: questEntry[6] ?? "none",
                                num_incomplete_sub_quests: questEntry[7] ?? "none",
                                total_sub_quests: questEntry[9] ?? "none"
                            )
                            self.quests.append(quest) 
                    } else {
                        print("getQuest: Received unexpected number of fields: \(questEntry.count) instead of \(self.nFields).")
                    }
                }
            }
        }.resume()
    }
}
