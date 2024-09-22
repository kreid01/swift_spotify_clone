import SwiftUI

struct HomeView: View {
    @StateObject var bladeeViewModel = ViewModel<AlbumResult>()
    @StateObject var dissectionViewModel = ViewModel<AlbumResult>()
    @StateObject var blackBearViewModel = ViewModel<AlbumResult>()
    @StateObject var paramoreViewModel = ViewModel<AlbumResult>()

    var mediaFilters = ["All", "Music", "Podcasts", "Audiobooks", "Courses"]
    var selectedMediaFilter = "All"

    @State var screenOffsetX: CGFloat = 0
    @State var opacity: Double = 1
    @State var menuOffsetX: CGFloat = -400

    func ChangeScreenOffset(offset: CGFloat) {
        screenOffsetX = offset
        if offset == 0 {
            opacity = 1
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                ProfileSideBar(menuOffset: $menuOffsetX, changeScreenOffset: ChangeScreenOffset)
                VStack {
                    HStack {
                        Spacer(minLength: 5)
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.white)
                            .onTapGesture {
                                withAnimation {
                                    menuOffsetX = -25
                                    screenOffsetX = 350
                                    opacity = 0.3
                                }
                            }
                        Filters(mediaFilters: mediaFilters, selectedMediaFilter: selectedMediaFilter)
                    }.frame(height: 70)
                        .padding(.leading, 15)
                    ScrollView {
                        if let bladeeAlbums = bladeeViewModel.data?.albums.items {
                            AlbumGridView(albums: bladeeAlbums)
                        }

                        HomeViewTitle(title: "Downloads")
                        if let dissectionAlbums = dissectionViewModel.data?.albums.items {
                            AlbumHGridView(albums: dissectionAlbums)
                        }

                        HomeViewTitle(title: "Made For You")
                        if let blackBearAlbums = blackBearViewModel.data?.albums.items {
                            LargeAlbumHGridView(albums: blackBearAlbums)
                        }

                        HomeViewTitle(title: "Jump Back In")
                        if let paramoreAlbums = paramoreViewModel.data?.albums.items {
                            LargeAlbumHGridView(albums: paramoreAlbums)
                        }
                    }.onAppear {
                        bladeeViewModel.fetch(url:
                            "https://api.spotify.com/v1/search?q=artist:bladee&type=album")
                        dissectionViewModel.fetch(url:
                            "https://api.spotify.com/v1/search?q=artist:dissection&type=album")
                        blackBearViewModel.fetch(url:
                            "https://api.spotify.com/v1/search?q=artist:blackbear&type=album")
                        paramoreViewModel.fetch(url:
                            "https://api.spotify.com/v1/search?q=artist:paramore&type=album")
                    }
                }
                .frame(width: 400)
                .background(Color(red: 25/255, green: 25/255, blue: 25/255))
                .offset(x: screenOffsetX)
            }
        }
    }
}

#Preview {
    HomeView()
}
