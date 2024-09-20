import SwiftUI

struct TrackView: View {
    @State var track: SearchTrack
    @State var index: Int
    @StateObject var trackViewModel = ViewModel<TrackObjectResult>()

    var body: some View {
        HStack {
            Text(String(index + 1))
                .foregroundStyle(.white)

            if let image = trackViewModel.data?.album.images {
                CacheAsyncImage(url: URL(string: image[0].url)!) {
                    phase in
                    switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                        case .empty:
                            ProgressView()
                        case .failure:
                            ProgressView()
                        @unknown default:
                            fatalError()
                    }
                }
            }
            Text(track.name)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .font(.system(size: 14))
                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .frame(width: 200)
                .offset(x: -15)
            Spacer()
            Image(systemName: "ellipsis")
                .foregroundStyle(.gray)
        }.onAppear {
            trackViewModel.fetch(url: "https://api.spotify.com/v1/tracks/\(track.id)")
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 8)
        .frame(height: 70)
    }
}

#Preview {
    LikedSongsView()
}

struct TrackViewFromId: View {
    @State var id: String
    @StateObject var trackViewModel = ViewModel<TrackObjectResult>()
    @StateObject var likedSongsViewModel = ViewModel<User>()
    @EnvironmentObject var playingSongViewModel: PlayingSongViewModel

    var body: some View {
        HStack {
            if let data = trackViewModel.data {
                if let image = data.album.images {
                    CacheAsyncImage(url: URL(string: image[0].url)!) {
                        phase in
                        switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60)
                                    .offset(x: -20)
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
                    Text(data.name)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    HStack {
                        ForEach(0 ..< data.artists.count) { i in
                            Text(data.artists[i].name)
                                .foregroundStyle(.gray)
                                .font(.system(size: 14))
                        }
                    }.lineLimit(1)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                }
                .frame(width: 200)
                .offset(x: -35)
                Spacer()
                Image(systemName: "ellipsis")
                    .foregroundStyle(.gray)
                    .onTapGesture {
                        likedSongsViewModel.Unlike(id: id, url: "http://localhost:8080/users/likes/1",
                                                   input: UpdateUserLikesInput(likeId: id))
                    }
            }
        }.onAppear {
            trackViewModel.fetch(url: "https://api.spotify.com/v1/tracks/\(id)")
        }
        .onTapGesture {
            if let track = trackViewModel.data {
                playingSongViewModel.AddSong(song: PlayingSongModel(
                    artist: track.artists.map { $0.name },
                    song: track.name, imageUrl: track.album.images?[0].url ?? ""
                ))
            }
        }
        .padding(.vertical, 8)
        .frame(height: 70)
    }
}
