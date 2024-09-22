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

struct PlayingSongView: View {
    @EnvironmentObject var playingSongViewModel: PlayingSongViewModel

    var body: some View {
        if playingSongViewModel.songs.count > 0 {
            HStack {
                HStack {
                    CacheAsyncImage(url: URL(string: playingSongViewModel.songs[0].imageUrl)!) {
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
                    }.padding(.bottom, 10)
                }
                VStack {
                    Text(playingSongViewModel.songs[0].song).foregroundStyle(.white)
                        .font(.system(size: 12))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    Text(playingSongViewModel.songs[0].artist[0]).foregroundStyle(.gray)
                        .font(.system(size: 12))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                }
                .offset(x: -20)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)

                HStack {
                    Image(systemName: "forward.fill")
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            playingSongViewModel.Next()
                        }
                    Image(systemName: "play.fill")
                }.foregroundStyle(.white)
                    .offset(x: -20)
            }
            .frame(width: 400, height: 70)
            .zIndex(0)
            .background(Color(red: 25/255, green: 35/255, blue: 25/255))
        }
    }
}

struct PullSongModel {
    let artist: [String]
    let album: String
    let track: PullSongTrack
}

struct PullSongTrack {
    let name: String
    let id: String
    let artists: [String]
    let imageUrl: String
}

class PullSongViewModel: ObservableObject {
    @Published var song: PullSongModel?

    func PullSong(_song: PullSongModel) {
        song = _song
    }
}

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
