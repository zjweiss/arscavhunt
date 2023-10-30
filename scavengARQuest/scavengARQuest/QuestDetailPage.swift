//
//  QuestDetailPage.swift
//  ScavengARQuest
//
//  Created by Abbie Tooman on 10/30/23.
//

import SwiftUI

struct CurrentQuest: Codable, Hashable, Identifiable {
    let id: String?
    let title: String?
    let image: String
    let subquest_id: String
    let status: String
    let time_estimate: String
    let total_quests: String
    
    static func preview() -> CurrentQuest {
        CurrentQuest(
             id: "1",
             title: "Campus Study Spots",
             image: "study_title",
             subquest_id: "1",
             status: "incomplete",
             time_estimate: "1 hr 30 min",
             total_quests: "6"
        )
    }
}

struct QuestDetailPage: View {
    let currentQuest: CurrentQuest = CurrentQuest.preview()
    @State private var username = ""

    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    //                    NavigationLink(destination: HomePage()) {
                    // Do we need this if it is a main page?
                    // Label("", systemImage: "lessthan")
                    //                    }
                    Spacer()
                    Image(systemName: "app.gift")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Image(systemName: "bell")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                }
                .padding(.horizontal)
                Text("Campus Study Spots")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.black)
                    .padding()
                Image("study_title")
                    .resizable()
                    .frame(width: 392, height: 174)
                    .foregroundStyle(.tint)
                    .cornerRadius(5.0)
                HStack{
                    VStack{
                        Text(currentQuest.time_estimate)
                            .font(.title2)
                        Text("Total Time")
                            .font(.title3)
                    }
                    Divider()
                        .background(Color.gray)
                        .frame(height: 70)
                        .padding(.horizontal, 30)
                    VStack{
                        Text(currentQuest.total_quests)
                            .font(.title2)
                        Text("Total Quests")
                            .font(.title3)
                    }
                }
                .padding(.bottom, 25)
                Text("What Awaits?")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                Text("Embark on a captivating journey to discover the artistic treasures scattered around the University of Michigan campus!")
                    .font(.body) // Set the font size
                    .foregroundColor(Color.gray) // Set the text color
                    .lineSpacing(8)
                    .padding(.bottom, 30)
                HStack{
                    VStack{
                        Text("JOIN A TEAM.")
                        TextField("Enter Team Id...", text: $username)
                            .frame(width: 132, height: 32)
                            .background(Color(red: 235 / 255.0, green: 232 / 255.0, blue: 232 / 255.0))
                    }
                    VStack {
                        HStack{
                            Divider()
                            .background(Color.gray)
                            .frame(height: 30)
                        }
                        Text("OR")
                        HStack{
                            Divider()
                            .background(Color.gray)
                            .frame(height: 30)
                        }
                    }
                    .padding(.horizontal)
                    VStack{
                        Text("GO SOLO.")
                        Button(action: {}) {
                            Text("Accept Quest")
                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                                .background(Color(red: 23 / 255.0, green: 37 / 255.0, blue: 84 / 255.0))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .frame(width: 128, height: 28)
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct QuestDetailPage_Preview: PreviewProvider {
    static var previews: some View {
        QuestDetailPage()
    }
}
