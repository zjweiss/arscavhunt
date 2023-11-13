//
//  ActiveQuestCard.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/12/23.
//

import SwiftUI

struct ActiveQuestCard: View {
    @State  var quest: Quest = Quest(quest_id: -1, quest_name: "", quest_thumbnail: "", quest_description: "", quest_rating: "", estimated_time: "", incomplete: -1, complete: -1, quest_status: "")
    @State private var isOnQuestTab = false

    
    
    var body: some View {
        ZStack{
            Button {
                isOnQuestTab.toggle()
            } label: {
                VStack {
                    if let imageUrl = URL(string: quest.quest_thumbnail) {
                        AsyncImage(url: imageUrl){
                            $0.resizable()
                                .scaledToFit()
                                .foregroundStyle(.tint)
                                .cornerRadius(5.0)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300, height: 200)
                    }
                    Spacer()
                    Text(quest.quest_name)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .navigationDestination(isPresented: $isOnQuestTab){
            ActiveQuestPage(quest: $quest)
        }    }
}

