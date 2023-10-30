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
    let image: String
    
    static func preview() -> QuestInfo {
        QuestInfo(
             id: "1",
             title: "Campus Study Spots",
             image: "study_title"
        )
    }
}

struct QuestListRowContent: View {
    let quests: [QuestInfo]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(quests, id: \.id) { quest in
                    VStack {
                        Image(quest.image)
                            .resizable()
                            .frame(width: 236, height: 174)
                            .foregroundStyle(.tint)
                            .cornerRadius(5.0)
                        Spacer()
                        if let title = quest.title {
                            Text(title)
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.trailing, 20)
                }
            }
        }
    }
}
