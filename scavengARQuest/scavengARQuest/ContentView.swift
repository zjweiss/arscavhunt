import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 2
    
    var body: some View {
        TabView(selection: $selectedTab){
            QuestPage()
                .tabItem() {
                    Image(systemName: "globe")
                    Text("Quests")
                }
                .tag(0)
            LeaderboardPage()
                .tabItem() {
                    Image(systemName: "globe")
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
                    Image(systemName: "globe")
                    Text("Chat")
                }
                .tag(3)
            ProfilePage()
                .tabItem() {
                    Image(systemName: "globe")
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
