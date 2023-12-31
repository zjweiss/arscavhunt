//
//  ActiveQuestCard.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/12/23.
//

import SwiftUI

struct ActiveQuestCard: View {
    var questId: Int
    @State private var isOnQuestTab = false
    private let store = ScavengarStore.shared

    
    
    var body: some View {
        let quest: Quest = store.questDict[questId] ?? Quest(quest_id: 0, quest_name: "", quest_thumbnail: "", quest_description: "", quest_rating: "", estimated_time: "", incomplete: -1, complete: -1, quest_status: "active")
        ZStack{
            Button {
                isOnQuestTab.toggle()
            } label: {
                VStack {
                    if let imageUrl = URL(string: quest.quest_thumbnail) {
                        GeometryReader { geometry in
                            AsyncImage(url: imageUrl) {
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
                    Text(quest.quest_name)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ProgressView(value: (Double(quest.complete) / Double(quest.complete + quest.incomplete)))
                }
            }
        }
        .navigationDestination(isPresented: $isOnQuestTab){
            ActiveQuestPage(questId: questId)
        }    }
}

