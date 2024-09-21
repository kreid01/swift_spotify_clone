import SwiftUI

struct UpdateUserLikesInput: Encodable {
    let likeId: String
}

struct UserResult: Decodable {
    let data: User
}

struct User: Decodable {
    let ID: Int
    let name: String
    let likes: [String]
    let followedArtists: [String]
    var likedAlbums: [String]
}

struct LikedSongsView: View {
    var mediaFilter: [String] = ["Alternative Hip-Hop", "Indie Rock", "Rock", "Metal", "Fast", "Country"]
    var selectedMediaFilter = ""
    @StateObject var likedSongsViewModel: ViewModel<UserResult> = .init()

    var body: some View {
        NavigationView {
            VStack {
                HomeViewTitle(title: "Liked Songs")
                Text("2053 songs")
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)

                HStack {
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 5)

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
                    .padding(.leading, 15)

                Filters(mediaFilters: mediaFilter, selectedMediaFilter: selectedMediaFilter)
                    .padding(.leading, 15)

                ScrollView {
                    HStack {
                        Image(systemName: "plus")
                            .padding(22)
                            .background(Color.gray)
                        Text("Add songs")
                            .frame(minWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: 200, height: 70)
                    .foregroundStyle(.white)
                    if let likedSongs = likedSongsViewModel.data?.data.likes {
                        ForEach(0 ..< likedSongs.count) { i in
                            TrackViewFromId(id: likedSongs[i]).onTapGesture {
                                
                            }
                        }
                    }
                }
                .refreshable {
                    likedSongsViewModel.fetch(url: "http://localhost:8080/users/1")
                }
                .padding(.horizontal, 20)
                .onAppear {
                    likedSongsViewModel.fetch(url: "http://localhost:8080/users/1")
                }
            }
            .background(Color(red: 25/255, green: 25/255, blue: 25/255))
        }
    }
}

#Preview {
    VStack {
        LikedSongsView()
    }
}
