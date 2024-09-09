import SwiftUI

struct ArtistView: View {
    @State var id: String
    @StateObject var artistViewModel = ArtistViewModel()
    @StateObject var trackViewModel = TrackViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                Spacer(minLength: 90)
                if let artist = artistViewModel.data {
                    CacheAsyncImage(url: URL(string: artist.images[0].url)!) {
                        phase in
                        switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 400, height: 400)
                            case .empty:
                                ProgressView()
                            case .failure:
                                ProgressView()
                            @unknown default:
                                fatalError()
                        }
                    }.onAppear {
                        trackViewModel.search(artist: artist.name)
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
                        CacheAsyncImage(url: URL(string: artist.images[2].url)!) {
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
                SearchViewTitle(title: "Featuring bladee")
                SearchViewTitle(title: "Fans also like")
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

struct TrackView: View {
    @State var track: SearchTrack
    @State var index: Int
    @StateObject var trackViewModel = SingleTrackViewModel()

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
            trackViewModel.fetch(id: track.id)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 8)
        .frame(height: 70)
    }
}
