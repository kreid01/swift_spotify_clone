import SwiftUI

struct Album {
    let id: String
    let name: String
    let artist: String
    let image: String
}

struct ContentView: View {
    @EnvironmentObject var pullSongViewModel: PullSongViewModel

    var body: some View {
        TabView {
            VStack {
                HomeView()
                PlayingSongView()
            }.background(Color(red: 25/255, green: 25/255, blue: 25/255))
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .toolbarBackground(
                    .black,
                    for: .tabBar)
            VStack {
                SearchView()
                PlayingSongView()
            }.background(Color(red: 25/255, green: 25/255, blue: 25/255))
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .toolbarBackground(
                    .black,
                    for: .tabBar)
            VStack {
                LibraryView()
                PlayingSongView()
            }.background(Color(red: 25/255, green: 25/255, blue: 25/255))
                .tabItem {
                    Label("Library", systemImage: "music.note.house.fill")
                }
                .toolbarBackground(
                    .black,
                    for: .tabBar)
        }.accentColor(.white)
            .overlay(
                SongPullView()
            )
    }
}

#if DEBUG
struct ContentSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlayingSongViewModel())
            .environmentObject(PullSongViewModel())
    }
}
#endif

struct PlayingSongModel {
    var artist: [String]
    var song: String
    var imageUrl: String
}

class PlayingSongViewModel: ObservableObject {
    @Published var songs: [PlayingSongModel] = []

    func AddSong(song: PlayingSongModel) {
        songs.append(song)
    }

    func Next() {
        songs.removeFirst()
    }
}
