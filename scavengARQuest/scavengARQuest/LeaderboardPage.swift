//
//  Leaderboard.swift
//  ScavengARQuest
//
//  Created by Janice Liu on 10/30/23.
//

import SwiftUI

struct UsersResponseWrapper: Codable {
    let data: [User]
}

struct User: Codable {
    let userId: Int
    let firstName: String
    let lastName: String
    let username: String
    let totalPoints: String
}

struct LeaderboardPage: View {
    @State private var response: UsersResponseWrapper?
    @State private var currentUser: User? = nil
    @State private var currentUserPlace: Int?
    private var serverUrl: String = "https://3.142.74.134"
    
    func getUsers() async throws -> UsersResponseWrapper {
        let endpoint = serverUrl + "/users/"
        
        guard let url = URL(string: endpoint) else {
            throw RequestError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RequestError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(UsersResponseWrapper.self, from: data)
        } catch {
            throw RequestError.invalidData
        }
    }
    
    func getUserPlaceString(place: Int) -> String {
        let placeAsString = String(place)
        if placeAsString.last == "1" {
            return placeAsString + "st"
        } else if placeAsString.last == "2" {
            return placeAsString + "nd"
        } else if placeAsString.last == "3" {
            return placeAsString + "rd"
        } else {
            return placeAsString + "th"
        }
    }
    
    var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        Spacer()
                        
                        Text("Leaderboard")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer(minLength: 20)
                        
                        Text(UserDefaults.standard.string(forKey: "canName") ?? "testUser")
                            .font(.system(size: 25))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer(minLength: 10)
                        
                        HStack {
                            VStack{
                                // TODO: loading indicator // UI: skeleton loader
                                Text(getUserPlaceString(place: currentUserPlace ?? -1))
                                    .font(.system(size: 25))
                                    .fontWeight(.bold)
                                Text("Place")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.gray) // Set the text color to gray
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            VStack{
                                Text(UserDefaults.standard.string(forKey: "points") ?? "0")
                                    .font(.system(size: 25).monospacedDigit())
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Text("Points")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.gray) // Set the text color to gray
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        
                        Divider() // Create a horizontal line
                        
                        Spacer(minLength: 20)
                        
                        Text("Ranking")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let unwrappedResponse = response {
                            ForEach(unwrappedResponse.data.indices, id: \.self) { index in
                                let user = unwrappedResponse.data[index]
                                LeaderboardRow(
                                    index: index,
                                    currentUserId: UserDefaults.standard.integer(forKey: "userID"),
                                    user: user
                                )
                            }
                        } else {
                            Text("Loading...")
                        }
                        
                    }
                    .task {
                        do {
                            response = try await getUsers()
                            
                            // Finds the current user from the list of users
                            if let unwrappedResponse = response {
                                for idx in 0..<unwrappedResponse.data.count {
                                    let user: User = unwrappedResponse.data[idx]
                                    if user.userId == UserDefaults.standard.integer(forKey: "userID") {
                                        currentUser = user
                                        currentUserPlace = idx + 1
                                    }
                                }
                            }
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

struct LeaderboardPage_Preview: PreviewProvider {
    static var previews: some View {
        LeaderboardPage()
    }
}
