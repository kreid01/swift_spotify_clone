import SwiftUI

struct HomeView: View {
    @StateObject var bladeeViewModel = SearchViewModel()
    @StateObject var dissectionViewModel = SearchViewModel()
    @StateObject var blackBearViewModel = SearchViewModel()
    @StateObject var paramoreViewModel = SearchViewModel()

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
                    bladeeViewModel.search(search: "Bladee")
                    dissectionViewModel.search(search: "Dissection")
                    blackBearViewModel.search(search: "Blackbear")
                    paramoreViewModel.search(search: "Paramore")
                }
            }.background(Color(red: 25/255, green: 25/255, blue: 25/255))
        }
    }
}

#Preview {
    ContentView()
}
