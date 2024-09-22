import SwiftUI

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
