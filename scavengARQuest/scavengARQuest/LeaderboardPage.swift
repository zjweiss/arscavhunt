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

struct User: Codable, Identifiable {
    let userId: Int
    let firstName: String
    let lastName: String
    let username: String
    let avatarUrl: String
    let totalPoints: String
    let ranking: Int
    
    var id: Int { return userId }

}

struct LeaderboardPage: View {
    @State private var response: UsersResponseWrapper?
    @State private var currentUser: User?
    private var serverUrl: String = "https://3.142.74.134"
    private let store = ScavengarStore.shared

    
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
            VStack {
                // Current User Information.
                Text("Leaderboard")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let user = currentUser {
                    Spacer()
                    
                    
                    Spacer(minLength: 20)
                    
                    AsyncImage(url: URL(string: user.avatarUrl)) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Image(systemName: "photo.fill")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 50, height: 50) // Adjust the width and height as needed
                    .cornerRadius(5.0)
                    
                    Text(user.firstName + " " + user.lastName)
                        .font(.system(size: 25))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer(minLength: 10)
                    
                    HStack{
                        VStack(alignment:.center){
                            Text(getUserPlaceString(place: user.ranking))
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                            Text("Place")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        VStack(alignment:.center) {
                            Text(user.totalPoints)
                                .font(.system(size: 25).monospacedDigit())
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("Points")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    
                    Divider() // Create a horizontal line
                } else {
                    VStack{
                        Text("Sign in now to start earning points!")
                           .font(.system(size: 22))
                           .fontWeight(.semibold)
                           .foregroundColor(Color.gray) // Set the text color to gray
                           .frame(maxWidth: .infinity, alignment: .center)
                       Divider() // Create a horizontal line
                   }
                }
                    Spacer(minLength: 20)
                                            
                    Text("Ranking")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    ScrollView {
                        if let unwrappedResponse = response {
                            ForEach(unwrappedResponse.data, id: \.userId) { user in
                                LeaderboardRow(
                                    currentUserId: store.userID,
                                    user: user
                                )
                            }
                        } else {
                            ProgressView()
                        }
                    }
            }.onAppear {
                Task {
                    do {
                        response = try await getUsers()
                        print("got response")
                        if let unwrappedResponse = response {
                            for idx in 0..<unwrappedResponse.data.count {
                                let user: User = unwrappedResponse.data[idx]
                                if user.userId == store.userID {
                                    print("found user")
                                    currentUser = user
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
            }.padding()
        }
    }
}

struct LeaderboardPage_Preview: PreviewProvider {
    static var previews: some View {
        LeaderboardPage()
    }
}
