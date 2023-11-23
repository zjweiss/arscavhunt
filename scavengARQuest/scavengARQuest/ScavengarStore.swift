//
//  ScavengarStore.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/21/23.
//

import Foundation

@Observable
final class ScavengarStore {
    static let shared = ScavengarStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other

    
    private(set) var quests = [Quest]()
    private(set) var questDict = [Int: Quest]()
    private(set) var questTeamDict = [Int: String]()
    private(set) var questTeamateDict = [Int: [Teamate]]()
    private(set) var questLocationDict = [Int: [Int]]()
    private(set) var locationDict = [Int: Location]()
    private(set) var username = ""
    private(set) var canName = ""
    private(set) var userID = 0
    private(set) var firstName = ""
    private(set) var lastName = ""
    private(set) var points = 0
    private let serverUrl = "https://3.142.74.134"
    
    
    func submitSoloQuestAcceptance(userID: Int, questID: Int) async {

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
            let (data, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode != 200{
                print ("httpCode \(http.statusCode)")
                print ("url: ")
                print("join solo: \(HTTPURLResponse.localizedString(forStatusCode: http.statusCode))")
            } else {
                //process the returned response
                guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                             print("login response: failed JSON deserialization")
                             return
                         }
                
                if let team_code = jsonResponse["team_code"] as? String {
                    questTeamDict[questID] = team_code
                }
            }
        } catch {
            print("login: NETWORKING ERROR")
            return
        }
        
        return
    }
    
    
    func submitTeamQuestAcceptance(userID: Int, questID: Int, teamID: String) async {

        //format of api endpoint: BASE/users/<user_id>/quests/<quest_id>/accept
        let urlString = serverUrl+"/users/" + String(userID) + "/quests/" + String(questID) + "/accept/"
        print(urlString)
        guard let apiUrl = URL(string: urlString ) else {
            print("login: Bad URL")
            return
        }
        
        let jsonObj = ["team_code": teamID]
               guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
                   print("login: jsonData serialization error")
                   return
               }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                print("accept quest: \(HTTPURLResponse.localizedString(forStatusCode: http.statusCode))")
                return
            }
        } catch {
            print("login: NETWORKING ERROR")
        }
        
        questTeamDict[questID] = teamID
        return
    }
    
    func getOtherTeamates(questID: Int) async throws {
        if let team_code = questTeamDict[questID] as? String {
            let endpoint = "https://3.142.74.134/teams/" + team_code
            print(endpoint)
            
            guard let url = URL(string: endpoint) else {
                throw RequestError.invalidUrl
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw RequestError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                //decoder.keyDecodingStrategy = .useDefaultKeys
                let decoded = try decoder.decode(TeamateResponseWrapper.self, from: data)
                questTeamateDict[questID] = decoded.data
                
            } catch {
                throw RequestError.invalidData
            }
            
        }
        
    }
    
    
    func getActiveQuestLocations(questID: Int) async throws {
        let userID = userID
        let endpoint = "https://3.142.74.134/users/" + String(userID) + "/quests/" + String(questID) + "/"
        print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            throw RequestError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RequestError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            //decoder.keyDecodingStrategy = .useDefaultKeys
            let decoded = try decoder.decode(ActiveQuestLocationsResponseWrapper.self, from: data)
            questLocationDict[questID] = []
            for location in decoded.data {
                locationDict[location.location_id] = location
                questLocationDict[questID]?.append(location.location_id)
            }
            
            if (decoded.data.count > 1){ // sorta hacky but it doesnt really matter which one we grab it from
                questTeamDict[questID] = decoded.data[0].team_code;
            }
            
            print(questLocationDict[questID])
        } catch {
            throw RequestError.invalidData
        }
    }
    

    func getQuests() async throws {
        let endpoint = serverUrl + "/users/\(userID)/quests/"
        print(endpoint)
        
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
            quests = quests_all
            
            // put it in a dict so we can access it elsewhere
            for quest in quests_all {
                questDict[quest.id] = quest
            }
            
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
    
    
    func submitLogin(inputUsername: String) async -> Int {
        let usernameLowercase = inputUsername.lowercased()
        print(usernameLowercase)
        let jsonObj = ["username": usernameLowercase]
               guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
                   print("login: jsonData serialization error")
                   return -1
               }
                       
               guard let apiUrl = URL(string: serverUrl+"/login/") else {
                   print("login: Bad URL")
                   return -1
               }
               
               var request = URLRequest(url: apiUrl)
               request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
               request.httpMethod = "POST"
               request.httpBody = jsonData

               do {
                   let (data, response) = try await URLSession.shared.data(for: request)
                   if let http = response as? HTTPURLResponse, http.statusCode != 200 && http.statusCode != 404 {
                       print ("httpCode \(http.statusCode)")
                       print ("url: ")
                       print("login22: \(HTTPURLResponse.localizedString(forStatusCode: http.statusCode))")
                   } else {
                       //process the returned response
                       guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                                    print("login response: failed JSON deserialization")
                                    return -1
                                }
                       
                       if jsonResponse["status"] as! String == "validUser"{
                           if let userArray = jsonResponse["user"] as? [Any] {
                               let fn = userArray[1] as? String ?? ""
                               let ln = userArray[2] as? String ?? ""
                               let uID = userArray[0] as? Int ?? 0
                               let pts = userArray[4] as? Int ?? 0
                               let canolicalName = fn + " " + ln
                               canName = canolicalName
                               userID = uID
                               firstName = fn
                               lastName = ln
                               points = pts

                           }
                           username = usernameLowercase
                           return 1
                       }
                       return -1
                   }
               } catch {
                   print("login: NETWORKING ERROR")
                   return -1
               }
               return -1
           }
    
    
    
    
    
}
