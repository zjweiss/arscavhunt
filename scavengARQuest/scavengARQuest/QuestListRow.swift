//import SwiftUI
//
//struct QuestListRow: View {
//    let quests: [Quest]
//
//    var body: some View {
//        ScrollView(.horizontal) {
//            LazyHStack {
//                ForEach(quests) { quest in
//                    VStack {
//                        Image(systemName: "app.gift" )
//                            .resizable()
//                            .frame(width: 236, height: 174)
//                            .foregroundStyle(.tint)
//                            .cornerRadius(5.0)
//                        Spacer()
//                        if quest.quest_name != "none" {
//                            Text(quest.name)
//                                .font(.title2)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                        }
//                    }
//                    .padding(.trailing, 20)
//                }
//            }
//        }
//    }
//}
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
                    NavigationLink(destination: QuestDetailPage()) {
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
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                    .id(quest.id)
                    .padding(.trailing, 20)
                }
            }
        }
    }
}
