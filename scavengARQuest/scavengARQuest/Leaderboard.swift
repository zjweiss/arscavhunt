//
//  Leaderboard.swift
//  ScavengARQuest
//
//  Created by Abbie Tooman on 10/30/23.
//

import SwiftUI

struct LeaderboardPage: View {
    let leaderBoard: [LeaderboardInfo] = [
        LeaderboardInfo(
             id: "1",
             name: "Kendall Jenner",
             place: "1",
             points: "188",
             image: "user_head"
        ),
        LeaderboardInfo(
             id: "2",
             name: "Abbie Tooman",
             place: "2",
             points: "130",
             image: "user_head"
        ),
        LeaderboardInfo(
             id: "3",
             name: "Zach Weis",
             place: "3",
             points: "92",
             image: "user_head"
        ),
        LeaderboardInfo(
             id: "4",
             name: "Jane Doe",
             place: "4",
             points: "90",
             image: "user_head"
        )

    ]
    
    let curUserLeaderboard: LeaderboardInfo =
        LeaderboardInfo(
        id: "1",
        name: "Jane Doe",
        place: "4",
        points: "90",
        image: "user_head")
    
    
    var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        HStack {
                            Button(action: {
                                // TODO: add back button action
                            }) {
                                Image(systemName: "chevron.left")
                                    .scaleEffect(0.6)
                                    .font(Font.title.weight(.medium))
                            }
                            Spacer()
                            Image(systemName: "app.gift")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                            Image(systemName: "bell")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                        }
                        Spacer()
                        Text("Leaderboard")
                            .font(.custom("Times New Roman", size: 30))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text(curUserLeaderboard.name ?? "")
                            .font(.custom("Times New Roman", size: 25))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            VStack{
                                HStack{
                                    Text(curUserLeaderboard.place ?? "-1")
                                        .font(.custom("Times New Roman", size: 30))
                                        .fontWeight(.bold)
                                    Text("th")
                                        .font(.custom("Times New Roman", size: 30))
                                        .fontWeight(.bold)
                                }
                                Text("Place")
                                    .font(.custom("Times New Roman", size: 12))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.gray) // Set the text color to gray
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            VStack{
                                Spacer()
                                Image(curUserLeaderboard.image)
                                    .resizable()
                                    .frame(width: 100, height: 100) // Adjust the size as needed
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2)) // Optional: Add a border
                                    .shadow(radius: 5) // Optional: Add a shadow
                                Spacer()
                            }
                            VStack{
                                Text(curUserLeaderboard.points ?? "0")
                                    .font(.custom("Times New Roman", size: 30))
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Text("Points")
                                    .font(.custom("Times New Roman", size: 12))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.gray) // Set the text color to gray
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        Divider() // Create a horizontal line
                        Spacer()
                        Text("Ranking")
                            .font(.custom("Times New Roman", size: 20))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        // TODO: figure out how to push pic/name to the left
                        LeaderboardInfoContent(leaderboard: leaderBoard)
                            .frame(maxWidth: .infinity)
                            .frame(maxWidth: .infinity, alignment: .leading)
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
