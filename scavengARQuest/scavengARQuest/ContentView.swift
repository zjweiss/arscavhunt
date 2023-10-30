import SwiftUI

struct ContentView: View {
    @State private var searchText = "" // Define and declare searchText as a @State property
    let questInfo: [QuestInfo] = [
        QuestInfo(id: "1", title: "Campus Study Spots"),
        QuestInfo(id: "2", title: "Campus Eats"),
        QuestInfo(id: "3", title: "Campus Fun"),
    ]
    
    let activeQuestInfo: [QuestInfo] = [
        QuestInfo(id: "1", title: "Campus Study Spots"),
    ]

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("ScavangAR")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Image(systemName: "globe")
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
                Spacer()
                QuestListRowContent(quests: activeQuestInfo)
                    .padding(.vertical)
                Text("Trending")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                QuestListRowContent(quests: questInfo)
                Spacer()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
