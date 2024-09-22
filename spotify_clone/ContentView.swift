import SwiftUI

struct Album {
    let id: String
    let name: String
    let artist: String
    let image: String
}

struct ContentView: View {
    @EnvironmentObject var pullSongViewModel: PullSongViewModel

    @State var screenOffsetX: CGFloat = 0
    @State var opacity: Double = 1
    @State var menuOffsetX: CGFloat = -400

    func ChangeScreenOffset(offset: CGFloat) {
        screenOffsetX = offset
        if offset == 0 {
            opacity = 1
        }
    }

    func openSidebar() {
        withAnimation {
            menuOffsetX = -25
            screenOffsetX = 350
            opacity = 0.3
        }
    }

    func closeSidebar() {
        withAnimation {
            menuOffsetX = -400
            screenOffsetX = 0
            opacity = 1
        }
    }

    var body: some View {
        ZStack {
            ProfileSideBar(menuOffset: $menuOffsetX, changeScreenOffset: ChangeScreenOffset)
            TabView {
                VStack {
                    HomeView(openSidebar: openSidebar, closeSidebar: closeSidebar)
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
                    LibraryView(openSidebar: openSidebar, closeSidebar: closeSidebar)
                    PlayingSongView()
                }.background(Color(red: 25/255, green: 25/255, blue: 25/255))
                    .tabItem {
                        Label("Library", systemImage: "music.note.house.fill")
                    }
                    .toolbarBackground(
                        .black,
                        for: .tabBar)
            }.accentColor(.white)
                .offset(x: screenOffsetX)
                .overlay(
                    SongPullView()
                )
        }
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
