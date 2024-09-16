import SwiftUI

struct LPView: View {
    @State var id: String
    @StateObject var lpViewModel: ViewModel<SpotifyAlbum> = .init()
    @StateObject var searchViewModel: ViewModel<AlbumResult> = .init()
    @StateObject var likedSongsViewModel: ViewModel<UserResult> = .init()
    @StateObject var userViewModel: ViewModel<UserResult> = .init()

    init(id: String) {
        self.id = id
    }

    var body: some View {
        VStack {
            ScrollView {
                Spacer(minLength: 100)
                if let album = lpViewModel.data {
                    CacheAsyncImage(url: URL(string: album.images[0].url)!) {
                        phase in
                        switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 260, height: 500)
                                    .scaledToFit()
                            case .empty:
                                ProgressView()
                            case .failure:
                                ProgressView()
                            @unknown default:
                                fatalError()
                        }
                    }
                    Spacer(minLength: 100)
                    Text(lpViewModel.data?.name ?? "")
                        .foregroundStyle(.white)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                    HStack {
                        ArtistImage(artistId: album.artists[0].id, height: 20, width: 20)
                            .frame(width: 20, height: 20)
                        NavigationLink(destination: ArtistView(id: album.artists[0].id)) {
                            Text(album.artists[0].name)
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                        }

                        Spacer()
                    }.padding(.leading, 20)

                    Text("Album - \(album.release_date.prefix(4))")
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                    HStack {
                        CacheAsyncImage(url: URL(string: album.images[2].url)!) {
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
                            if let user = userViewModel.data?.data {
                                Image(systemName: user.likedAlbums.contains(id) ? "checkmark" : "plus.circle")
                                    .frame(width: 25, height: 25)
                                    .fontWeight(.bold)
                                    .font(.system(size:
                                        user.likedAlbums.contains(id) ? 12 : 24))
                                    .foregroundStyle(user.likedAlbums.contains(id) ?.black : .gray)
                                    .background(user.likedAlbums.contains(id) ?.green : .clear)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 5)
                                    .onTapGesture {
                                        if user.likedAlbums.contains(id) {
                                            lpViewModel.Unlike(id: id,
                                                               url: "http://localhost:8080/users/liked-albums/1",
                                                               input: UpdateLikedAlbum(albumId: id))
                                        } else {
                                            lpViewModel.Like(id: id, url: "http://localhost:8080/users/liked-albums/1",
                                                             input: UpdateLikedAlbum(albumId: id))
                                        }
                                    }
                            } else {
                                Image(systemName: "plus.circle")
                                    .frame(width: 25, height: 25)
                                    .font(.system(size: 32))
                                    .cornerRadius(20)
                                    .padding(.horizontal, 5)
                                    .foregroundStyle(.white)
                                    .onTapGesture {
                                        lpViewModel.Like(id: id, url:
                                            "http://localhost:8080/users/liked-albums/1",
                                            input: UpdateLikedAlbum(albumId: id))
                                    }
                            }

                            Image(systemName: "arrow.down")
                                .frame(width: 25, height: 25)
                                .fontWeight(.bold)
                                .font(.system(size: 12))
                                .background(.green)
                                .cornerRadius(20)
                                .padding(.horizontal, 5)

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
                    }.frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(0 ..< album.tracks.total, id: \.self) { i in
                        HStack {
                            VStack {
                                Text(album.tracks.items[i].name)
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                                HStack {
                                    ForEach(0 ..< album.tracks.items[i].artists.count, id: \.self) { j in
                                        Text(album.tracks.items[i].artists[j].name)
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            }
                            Spacer()
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.gray)
                        }
                        .onTapGesture {
                            likedSongsViewModel.Like(id: album.tracks.items[i].id, url: "http://localhost:8080/users/likes/1", input: UpdateUserLikesInput(likeId: album.tracks.items[i].id))
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 8)
                    }

                    VStack {
                        Text(convertDateString(album.release_date)!)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        HStack {
                            Text("\(album.total_tracks) songs")
                            Text("-")
                            Text(convertMillisecondsToHoursMinutes(ms: album.tracks.items.reduce(0) { x, y in
                                x + y.duration_ms
                            }))
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .foregroundStyle(.white)
                    .padding(.leading, 25)

                    HStack {
                        Circle().frame(width: 50, height: 50)
                        Text(album.artists[0].name)
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    .onAppear {
                        searchViewModel.fetch(url: "https://api.spotify.com/v1/search?q=artist:\(album.artists[0].name)&type=album")
                    }

                    HomeViewTitle(title: "More by \(album.artists[0].name)")
                    if let moreByAlbums = searchViewModel.data?.albums.items {
                        AlbumHGridView(albums: moreByAlbums)
                    }

                    HomeViewTitle(title: "You might also like")
                    if let alsoLikeByAlbums = searchViewModel.data?.albums.items {
                        AlbumHGridView(albums: alsoLikeByAlbums)
                    }

                    Text("\(album.copyrights[0].type) \(album.copyrights[0].text)")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .font(.system(size: 10))
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 400)
            .padding(.bottom, 20)
            .background(Color(red: 25/255, green: 25/255, blue: 25/255))
            .onAppear {
                lpViewModel.fetch(url: "https://api.spotify.com/v1/albums/\(id)")
                userViewModel.fetch(url: "http://localhost:8080/users/1")
            }
        }.navigationTitle("")
    }
}

#Preview {
    LPView(id: "0NCLTcIG4kbORFysmf56BW")
}

func convertDateString(_ dateString: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"

    if let date = inputFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"

        return outputFormatter.string(from: date)
    } else {
        return nil
    }
}

func convertMillisecondsToHoursMinutes(ms: Int) -> String {
    let totalSeconds = ms/1000
    let minutes = (totalSeconds/60) % 60
    let hours = totalSeconds/3600

    if hours > 0 {
        return "\(hours)hr \(minutes)min"
    } else {
        return "\(minutes)min"
    }
}
