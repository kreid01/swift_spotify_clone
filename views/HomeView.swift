import SwiftUI

struct HomeView: View {
    @StateObject var bladeeViewModel = ViewModel<AlbumResult>()
    @StateObject var dissectionViewModel = ViewModel<AlbumResult>()
    @StateObject var blackBearViewModel = ViewModel<AlbumResult>()
    @StateObject var paramoreViewModel = ViewModel<AlbumResult>()

    var body: some View {
        NavigationView {
            VStack {
                FilterView()
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
            }.background(Color(red: 25/255, green: 25/255, blue: 25/255))
        }
    }
}

#Preview {
    HomeView()
}
