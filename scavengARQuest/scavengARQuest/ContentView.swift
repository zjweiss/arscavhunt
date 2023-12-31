import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab){
            HomePage()
                .tabItem() {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            LeaderboardPage()
                .tabItem() {
                    Image(systemName: "chart.bar")
                    Text("Leaderboard")
                }
                .tag(1)
            ChatPage()
                .tabItem() {
                    Image(systemName: "ellipsis.message")
                    Text("Chat")
                }
                .tag(2)
            LoginView()
                .tabItem() {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
