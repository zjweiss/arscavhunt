//
//  HomePage.swift
//  ScavengARQuest
//
//  Created by Abbie Tooman on 10/30/23.
//

import SwiftUI

struct HomePage: View {
    @State private var searchText = "" // Define and declare searchText as a @State property
    let questInfo: [QuestInfo] = [
        QuestInfo(id: "2", title: "Campus Murals", image: "campus_murals"),
        QuestInfo(id: "1", title: "Campus Study Spots", image: "study_title"),
        QuestInfo(id: "3", title: "Campus Fun", image: "study_title"),
    ]
    
    let activeQuestInfo: [QuestInfo] = [
        QuestInfo(id: "1", title: "Campus Study Spots", image: "study_title"),
    ]

    var body: some View {
            NavigationView {
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
                        Text("Active")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical)
                        QuestListRowContent(quests: activeQuestInfo)
                            .frame(maxWidth: 275)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Capsule()
                            .foregroundColor(Color.green)
                            .frame(maxWidth: 236)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack{
                            Text("Progress")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("5/6 quests")
                                .font(.subheadline)
                                .offset(x: -124, y: 0)
                        }
                        Text("Trending")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 40)
                        QuestListRowContent(quests: questInfo)
                            .frame(maxWidth: .infinity)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text("Difficult Quests")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 40)
                        QuestListRowContent(quests: questInfo)
                            .frame(maxWidth: .infinity)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
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

