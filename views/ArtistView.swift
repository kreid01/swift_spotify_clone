import SwiftUI

struct UpdateFollowedArtistInput: Encodable {
    let artistId: String
}

struct ArtistView: View {
    @State var id: String
    @StateObject var artistViewModel = ViewModel<Artist>()
    @StateObject var trackViewModel = ViewModel<TracksResult>()
    @StateObject var searchViewModel = ViewModel<AlbumResult>()
    @StateObject var playlistViewModel = ViewModel<PlaylistResult>()
    @StateObject var appearsOnViewModel = ViewModel<ItemResult>()
    @StateObject var likedSongsViewModel = ViewModel<User>()
    @StateObject var userViewModel = ViewModel<User>()

    @State var opacity: CGFloat = 1
    @State var hideNavBar = false

    func calculateOpacity(for scrollViewOffset: CGFloat) -> Double {
        let startOffset: CGFloat = 60
        let endOffset: CGFloat = -320

        let clampedOffset = min(max(scrollViewOffset, endOffset), startOffset)

        return (clampedOffset - endOffset)/(startOffset - endOffset)
    }

    var body: some View {
        VStack {
            ScrollView {
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.frame(in: .global).minY) { minY in
                            self.opacity = calculateOpacity(for: minY)

                            if minY <= -320 {
                                self.hideNavBar = false
                            } else {
                                self.hideNavBar = true
                            }
                        }
                }
                .frame(height: 0)
                Spacer(minLength: 50)
                if let artist = artistViewModel.data {
                    if let images = artist.images {
                        CacheAsyncImage(url: URL(string: images[0].url)!) {
                            phase in
                            switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 400, height: 400)
                                        .opacity(self.opacity)
                                        .scaledToFill()
                                case .empty:
                                    ProgressView()
                                case .failure:
                                    ProgressView()
                                @unknown default:
                                    fatalError()
                            }
                        }.onAppear {
                            trackViewModel.fetch(url:
                                "https://api.spotify.com/v1/search?q=artist:\(artist.name)&type=track&limit=50")
                            searchViewModel.fetch(url: "https://api.spotify.com/v1/search?q=artist:\(artist.name)&type=album")
                            playlistViewModel.fetch(url: "https://api.spotify.com/v1/search?q=artist:\(artist.name)&type=playlist")
                            appearsOnViewModel.fetch(url: "https://api.spotify.com/v1/artists/\(artist.id)/albums?limit=50&include_groups=appears_on")
                            userViewModel.fetch(url: "http://localhost:8080/users/1")
                        }
                    }
                    Text(artist.name)
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .offset(y: 64)

                    Spacer(minLength: 100)
                    HStack {
                        if let images = artist.images {
                            CacheAsyncImage(url: URL(string: images[2].url)!) {
                                phase in
                                switch phase {
                                    case .success(let image):
                                        HStack {
                                            image
                                                .resizable()
                                                .frame(width: 30, height: 45)
                                        }
                                        .frame(width: 40, height: 50)
                                        .border(Color(red: 41/255, green: 41/255, blue: 41/255), width: 5)
                                        .cornerRadius(6)
                                        .frame(width: 45, height: 55)
                                        .border(.gray, width: 3)
                                        .cornerRadius(6)
                                        .offset(x: -5)
                                    case .empty:
                                        ProgressView()
                                    case .failure:
                                        ProgressView()
                                    @unknown default:
                                        fatalError()
                                }
                            }
                        }

                        HStack {
                            if let user = userViewModel.data {
                                Text(user.followedArtists.contains(id) ? "Following" : "Follow")
                                    .frame(width: 80)
                                    .padding(10)
                                    .background(user.followedArtists.contains(id) ? Color.green : Color.clear)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        if user.followedArtists.contains(id) {
                                            artistViewModel.Unlike(id: id, url: "http://localhost:8080/users/1",
                                                                   input: UpdateFollowedArtistInput(artistId: id))
                                        } else {
                                            artistViewModel.Like(id: id, url: "http://localhost:8080/users/1",
                                                                 input: UpdateFollowedArtistInput(artistId: id))
                                        }
                                    }
                            } else {
                                Text("Follow")
                                    .frame(width: 80)
                                    .padding(10)
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                                    .background(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white, lineWidth: 1))
                                    .onTapGesture {
                                        artistViewModel.Like(id: id, url: "http://localhost:8080/users/1",
                                                             input: UpdateFollowedArtistInput(artistId: id))
                                    }
                            }

                            Image(systemName: "ellipsis")
                                .frame(width: 30, height: 30)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 5)
                        }.offset(x: -20)

                        Spacer()

                        Image(systemName: "shuffle")
                            .frame(width: 50, height: 50)
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.gray)

                        Image(systemName: "play.fill")
                            .frame(width: 50, height: 50)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .background(.green)
                            .cornerRadius(30)
                            .padding(.trailing, 25)
                    }
                }

                SearchViewTitle(title: "Popular")
                if let popularSongs = trackViewModel.data?.tracks.items {
                    ForEach(0 ..< popularSongs.prefix(5).count, id: \.self) { i in
                        TrackView(track: popularSongs[i], index: i)
                            .onTapGesture {
                                likedSongsViewModel.Like(id: popularSongs[i].id, url: "http://localhost:8080/users/likes/1", input: UpdateUserLikesInput(likeId: popularSongs[i].id))
                            }
                    }
                }

                SearchViewTitle(title: "Popular releases")
                if let releases = searchViewModel.data?.albums.items {
                    PopularReleaseView(releases: releases)
                }

                SearchViewTitle(title: "Featuring bladee")
                if let featuredPlaylists = playlistViewModel.data?.playlists.items {
                    LargePlaylistHGridView(featuredPlaylists: featuredPlaylists)
                }

                SearchViewTitle(title: "Fans also like")
                if let popularSongs = trackViewModel.data?.tracks.items {
                    FansAlsoLike(artists: Array(Set(popularSongs.flatMap { $0.artists }.filter { $0.name != artistViewModel.data?.name })))
                }

                VStack {
                    SearchViewTitle(title: "Appears on")
                    if let appearsOnAlbums = appearsOnViewModel.data?.items {
                        LargeAlbumHGridView(albums: appearsOnAlbums)
                    }
                }.offset(y: -15)
            }
            .background(Color(red: 25/255, green: 25/255, blue: 25/255))
        }.onAppear {
            artistViewModel.fetch(url: "https://api.spotify.com/v1/artists/\(id)")
        }.frame(width: 400)
            .navigationTitle(!hideNavBar ? artistViewModel.data?.name ?? "" : "")
    }
}

#if DEBUG
struct LPSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlayingSongViewModel())
            .environmentObject(PullSongViewModel())
    }
}
#endif
