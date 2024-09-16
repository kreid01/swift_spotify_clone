import SwiftUI

struct LibraryView: View {
    @StateObject var userViewModel = ViewModel<UserResult>()

    var gridLayout: [GridItem] = [
        GridItem(.fixed(120)),
        GridItem(.fixed(120)),
        GridItem(.fixed(120)),
    ]

    var mediaFilters = ["Playlists", "Podcasts and courses", "Albums", "Artists", "Downloaded"]
    var selectedMediaFilter = ""

    @State var screenOffsetX: CGFloat = 0
    @State var opacity: Double = 1
    @State var menuOffsetX: CGFloat = -400

    var body: some View {
        NavigationView {
            ZStack {
                ProfileSideBar(menuOffset: $menuOffsetX)
                VStack {
                    HStack {
                        Circle()
                            .frame(width: 32, height: 32)
                            .padding(.leading, 20)
                            .foregroundStyle(.white)
                            .onTapGesture {
                                withAnimation {
                                    menuOffsetX = -25
                                    screenOffsetX = 350
                                    opacity = 0.3
                                }
                            }
                        Text("Your Library")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                    }

                    Filters(mediaFilters: mediaFilters, selectedMediaFilter: selectedMediaFilter)
                        .padding(.leading, 10)

                    if let user = userViewModel.data?.data {
                        ScrollView {
                            LazyVGrid(columns: gridLayout) {
                                NavigationLink(destination: LikedSongsView()) {
                                    VStack {
                                        HStack {
                                            Image(systemName: "heart")
                                        }
                                        .frame(width: 110, height: 110)
                                        .background(.white)
                                        .cornerRadius(5)
                                        Text("Liked Songs")
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .offset(x: 5)
                                        Text("Playlist")
                                            .foregroundStyle(.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .offset(x: 5, y: -5)
                                    }
                                }
                                ForEach(0 ..< user.likedAlbums.count) { i in
                                    AlbumFromIdView(id: user.likedAlbums[i])
                                }
                                ForEach(0 ..< user.followedArtists.count) { i in
                                    ArtistFromIdView(id: user.followedArtists[i])
                                }
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
                .offset(x: screenOffsetX)
                .opacity(opacity)
                .background(Color(red: 25/255, green: 25/255, blue: 25/255))
                .onTapGesture {
                    withAnimation {
                        menuOffsetX = -400
                        screenOffsetX = 0
                        opacity = 1
                    }
                }
                .onAppear {
                    userViewModel.fetch(url: "http://localhost:8080/users/1")
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}
