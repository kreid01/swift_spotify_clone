import SwiftUI

struct ArtistView: View {
    @State var id: String
    @StateObject var artistViewModel = ArtistViewModel()
    @StateObject var trackViewModel = TrackViewModel()
    @StateObject var searchViewModel = SearchViewModel()
    @StateObject var playlistViewModel = PlaylistViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
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
                                        .scaledToFill()
                                case .empty:
                                    ProgressView()
                                case .failure:
                                    ProgressView()
                                @unknown default:
                                    fatalError()
                            }
                        }.onAppear {
                            trackViewModel.search(artist: artist.name)
                            searchViewModel.search(search: artist.name)
                            playlistViewModel.search(artist: artist.name)
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
                            Text("Follow")
                                .frame(width: 80)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white, lineWidth: 1))
                                .foregroundColor(.white)

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

                SearchViewTitle(title: "Appears on")
            }
            .background(Color(red: 25/255, green: 25/255, blue: 25/255))
        }.onAppear {
            artistViewModel.fetch(id: id)
        }.frame(width: 400)
    }
}

#Preview {
    ArtistView(id: "2xvtxDNInKDV4AvGmjw6d1")
}

struct FansAlsoLike: View {
    @State var artists: [TrackArtist]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(artists) { artist in
                    NavigationLink(destination: ArtistView(id: artist.id)) {
                        VStack {
                            ArtistImage(artistId: artist.id, height: 160, width: 160)
                            Text(artist.name)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                                .frame(width: 140, height: 40, alignment: .top)
                                .foregroundColor(.white)
                                .offset(y: 30)
                        }.offset(x: 0, y: 25)
                    }.frame(width: 160, height: 220)
                }
            }
        }.scrollIndicators(.hidden)
            .padding(.trailing, 30)
            .offset(x: 14, y: -25)
    }
}

struct ArtistImage: View {
    @State var artistId: String
    @State var height: CGFloat
    @State var width: CGFloat

    @StateObject var artistViewModel = ArtistViewModel()

    var body: some View {
        HStack {
            if let images = artistViewModel.data?.images {
                CacheAsyncImage(url: URL(string: images[0].url)!) {
                    phase in
                    switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: width, height: height)
                                .cornerRadius(100)
                                .scaledToFill()
                        case .empty:
                            ProgressView()
                        case .failure:
                            ProgressView()
                        @unknown default:
                            fatalError()
                    }
                }
            }
        }.onAppear {
            artistViewModel.fetch(id: artistId)
        }
    }
}
