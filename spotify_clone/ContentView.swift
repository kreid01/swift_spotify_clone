import SwiftUI

struct Album {
    let id: String
    let name: String
    let artist: String
    let image: String
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .toolbarBackground(
                    .black,
                    for: .tabBar)
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .toolbarBackground(
                    .black,
                    for: .tabBar)
            HomeView()
                .tabItem {
                    Label("Library", systemImage: "music.note.house.fill")
                }
                .toolbarBackground(
                    .black,
                    for: .tabBar)
        }.accentColor(.white)
    }
}

#Preview {
    ContentView()
}

