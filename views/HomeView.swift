import SwiftUI

struct HomeView: View {
    var albums = [
        Album(id: "1", name: "Eversince", artist: "Bladee", image: "https://i.ebayimg.com/images/g/cIEAAOSwmURkJH-u/s-l1200.jpg"),
        Album(id: "2", name: "Eversince", artist: "Bladee", image: "https://i.ebayimg.com/images/g/cIEAAOSwmURkJH-u/s-l1200.jpg"),
        Album(id: "3", name: "Eversince", artist: "Bladee", image: "https://i.ebayimg.com/images/g/cIEAAOSwmURkJH-u/s-l1200.jpg"),
        Album(id: "4", name: "Eversince", artist: "Bladee", image: "https://i.ebayimg.com/images/g/cIEAAOSwmURkJH-u/s-l1200.jpg"),
        Album(id: "5", name: "Eversince", artist: "Bladee", image: "https://i.ebayimg.com/images/g/cIEAAOSwmURkJH-u/s-l1200.jpg"),
        Album(id: "6", name: "Eversince", artist: "Bladee", image: "https://i.ebayimg.com/images/g/cIEAAOSwmURkJH-u/s-l1200.jpg"),
        Album(id: "7", name: "Eversince", artist: "Bladee", image: "https://i.ebayimg.com/images/g/cIEAAOSwmURkJH-u/s-l1200.jpg"),
        Album(id: "8", name: "Eversince", artist: "Bladee", image: "https://i.ebayimg.com/images/g/cIEAAOSwmURkJH-u/s-l1200.jpg"),
    ]

    var body: some View {
        VStack {
            FilterView()
            ScrollView {
                AlbumGridView(albums: albums)

                HomeViewTitle(title: "Downloads")

                AlbumHGridView(albums: albums)

                HomeViewTitle(title: "Made For You")
                LargeAlbumHGirdView(albums: albums)

                HomeViewTitle(title: "Jump Back In")
                LargeAlbumHGirdView(albums: albums)
            }
        }.background(Color(red: 25/255, green: 25/255, blue: 25/255))
    }
}

#Preview {
    ContentView()
}
