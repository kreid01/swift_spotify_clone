import SwiftUI

struct SongPullView: View {
    @State var reset: (() -> Void)?

    @EnvironmentObject var pullSongViewModel: PullSongViewModel
    @EnvironmentObject var playingSongViewModel: PlayingSongViewModel
    @StateObject var likedSongsViewModel = ViewModel<Track>()

    @State var offsetY: CGFloat = 500

    var body: some View {
        if let song = pullSongViewModel.song {
            VStack {
                HStack {
                    CacheAsyncImage(url: URL(string: song.track.imageUrl)!) {
                        phase in
                        switch phase {
                            case .success(let image):
                                HStack {
                                    image
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }
                                .cornerRadius(6)
                                .frame(width: 45, height: 55)
                            case .empty:
                                ProgressView()
                            case .failure:
                                ProgressView()
                            @unknown default:
                                fatalError()
                        }
                    }
                    VStack {
                        Text(song.album)
                            .fontWeight(.bold)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        Text(song.track.artists[0])
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)

                Divider().foregroundColor(.gray)
                VStack {
                    HStack {
                        Image(systemName: "heart")
                        Text("Add to Liked Songs")
                    }.frame(height: 30)
                        .onTapGesture {
                            likedSongsViewModel.Like(id: song.track.id, url: "http://localhost:8080/users/likes/1", input: UpdateUserLikesInput(likeId: song.track.id))
                            pullSongViewModel.song = nil
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add to playlist")
                    }.frame(height: 30)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    HStack {
                        Image(systemName: "minus.circle")
                        Text("Hide song")
                    }.frame(height: 30)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    HStack {
                        Image(systemName: "plus.app")
                        Text("Add to queue")
                    }.frame(height: 30)
                        .onTapGesture {
                            playingSongViewModel.AddSong(song: PlayingSongModel(
                                artist: song.track.artists, song: song.track.name, imageUrl: song.track.imageUrl
                            ))
                            pullSongViewModel.song = nil
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }.frame(height: 30)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                }
                .padding(.horizontal, 25)
            }.foregroundStyle(.white)
                .onAppear {
                    withAnimation {
                        offsetY = 250
                    }
                }
                .background(Color(red: 20/255, green: 30/255, blue: 30/255))
                .offset(y: offsetY)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.height > 400 {
                                withAnimation {
                                    self.offsetY = 500
                                }
                            } else {
                                withAnimation {
                                    self.offsetY = 250
                                }
                            }
                        }
                        .onChanged { value in
                            if value.translation.height > 0 {
                                withAnimation {
                                    self.offsetY = 250 + value.translation.height
                                }
                            }
                        })
        }
    }
}
