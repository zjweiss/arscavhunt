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
                            .font(.subheadline)
                            // .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Image(player.image)
                        .resizable()
                        .frame(width: 25, height: 25) // Adjust the size as needed
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2)) // Optional: Add a border
                        .shadow(radius: 5) // Optional: Add a shadow
                    if let name = player.name {
                        Text(name)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                    if let points = player.points {
                        Text(points)
                            .font(.subheadline)
//                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
        }
    }
}
