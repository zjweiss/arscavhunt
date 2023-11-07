//
 //  LeaderboardRow.swift
 //  ScavengARQuest
 //
 //  Created by Janice Liu on 11/1/23.
 //
 import SwiftUI

 struct LeaderboardInfo: Codable, Hashable, Identifiable {

     let id: String?
     let name: String?
     let place: String?
     let points: String?
     let image: String

     static func preview() -> LeaderboardInfo {
         LeaderboardInfo(
              id: "1",
              name: "Jane Doe",
              place: "4th",
              points: "90",
              image: "user_head"
         )
     }
 }

 struct LeaderboardInfoContent: View {
    let leaderboard: [LeaderboardInfo]

    var body: some View {
        ForEach(leaderboard, id: \.id) {
            player in
            VStack {
                HStack{
                    if let place = player.place {
                        Text(place)
                            .font(.custom("Times New Roman", size: 20))
                            .padding(.horizontal, 5) // Add vertical padding between each player
                    }
                    Image(player.image)
                        .resizable()
                        .frame(width: 35, height: 35) // Adjust the size as needed
                        .clipShape(Circle())
                        .padding(.horizontal, 5) // Add vertical padding between each player
                        .shadow(radius: 5) // Optional: Add a shadow
                    if let name = player.name {
                        Text(name)
                            .font(.custom("Times New Roman", size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 5) // Add vertical padding between each player

                    }
                    Spacer()
                    if let points = player.points {
                        Text(points)
                            .font(.custom("Times New Roman", size: 20))
                            .padding(.horizontal, 5) // Add vertical padding between each player
                    }
                }
            }
            .padding(.vertical, 5) // Add vertical padding between each player
        }
    }
}
