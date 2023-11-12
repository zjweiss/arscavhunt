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
