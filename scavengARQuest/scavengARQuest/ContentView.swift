import SwiftUI

struct ContentView: View {
    @State private var searchText = "" // Define and declare searchText as a @State property

    var body: some View {
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
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
