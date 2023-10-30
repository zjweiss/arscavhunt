import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 2
    
    var body: some View {
        TabView(selection: $selectedTab){
            QuestPage()
                .tabItem() {
                    Image(systemName: "map")
                    Text("Quests")
                }
                .tag(0)
            LeaderboardPage()
                .tabItem() {
                    Image(systemName: "chart.bar")
                    Text("Leaderboard")
                }
                .tag(1)
            HomePage()
                .tabItem() {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(2)
            ChatPage()
                .tabItem() {
                    Image(systemName: "ellipsis.message")
                    Text("Chat")
                }
                .tag(3)
            ProfilePage()
                .tabItem() {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(4)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
