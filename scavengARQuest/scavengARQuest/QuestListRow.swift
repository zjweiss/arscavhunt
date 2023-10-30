//
//  QuestListRow.swift
//  ScavengARQuest
//
//  Created by Abbie Tooman on 10/29/23.
//

import SwiftUI

struct QuestInfo: Codable, Hashable, Identifiable {

    let id: String?
    let title: String?
    
    static func preview() -> QuestInfo {
        QuestInfo(
             id: "1",
             title: "Campus Study Spots"
        )
    }
}

struct QuestListRowContent: View {
    let quests: [QuestInfo]
    
    var body: some View {
        LazyVStack {
            ForEach(quests, id: \.id) { quest in
                VStack {
                    Image("study_title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.tint)
                        .padding()
                    Spacer()
                    if let title = quest.title {
                        Text(title)
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
}
