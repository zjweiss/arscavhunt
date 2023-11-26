//
//  InactiveQuestCard.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/12/23.
//

import SwiftUI

struct InactiveQuestCard: View {
    @State  var quest: Quest = Quest(quest_id: -1, quest_name: "", quest_thumbnail: "", quest_description: "", quest_rating: "", estimated_time: "", incomplete: -1, complete: -1, quest_status: "")
    @State private var isAcceptingQuest = false

    
    
    var body: some View {
        ZStack{
            Button {
                isAcceptingQuest.toggle()
            } label: {
                VStack {
                    if let imageUrl = URL(string: quest.quest_thumbnail) {
                        GeometryReader { geometry in
                            AsyncImage(url: imageUrl){
                                $0.resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width - 20, height: (geometry.size.width - 20) * 0.66) // 40 for padding, adjust as needed
                                    .cornerRadius(5.0)
                                    .padding(.horizontal, 10) // Adjust padding as needed
                                    .foregroundStyle(.tint)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .frame(width: 300, height: 200)
                    }
                    Spacer()
                    Text(quest.quest_name)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                }
            }
        }
        .navigationDestination(isPresented: $isAcceptingQuest){
            QuestDetailPage(quest: $quest)
        }    }
}

