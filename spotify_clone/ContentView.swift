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
            VStack {
                HomeView()
                PlayingSongView()
            }
            .background(Color(red: 25/255, green: 25/255, blue: 25/255))
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
            VStack {
                LikedSongsView()
                PlayingSongView()
            }
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

struct PlayingSongView: View {
    @EnvironmentObject var playingSongViewModel: PlayingSongViewModel

    var body: some View {
        if let _ = playingSongViewModel.song {
            HStack {
                HStack {
                    if let image = playingSongViewModel.imageUrl {
                        CacheAsyncImage(url: URL(string: image)!) {
                            phase in
                            switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .scaledToFit()
                                case .empty:
                                    ProgressView()
                                case .failure:
                                    ProgressView()
                                @unknown default:
                                    fatalError()
                            }
                        }
                    }
                    VStack {
                        if let song = playingSongViewModel.song {
                            Text(song).foregroundStyle(.white)
                                .font(.system(size: 12))
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        }
                        if let artists = playingSongViewModel.artist {
                            Text(artists[0]).foregroundStyle(.gray)
                                .font(.system(size: 12))
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        }
                    }
                }.padding(.bottom, 10)
            }
            .background(Color(red: 25/255, green: 25/255, blue: 25/255))
            .frame(height: 55)
        }
    }
}

class PlayingSongViewModel: ObservableObject {
    @Published var artist: [String]?
    @Published var song: String?
    @Published var imageUrl: String?
}
