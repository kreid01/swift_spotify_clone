import SwiftUI

struct AlbumGridView: View {
    @State var albums: [SearchSpotifyAlbum]

    var gridLayout: [GridItem] = [
        GridItem(.fixed(180)),
        GridItem(.fixed(180)),
    ]

    var body: some View {
        LazyVGrid(columns: gridLayout, content: {
            ForEach(albums.prefix(upTo: 8), id: \.id) {
                album in
                NavigationLink(destination: LPView(id: album.id)) {
                    HStack {
                        if let images = album.images {
                            CacheAsyncImage(url: URL(string: images[0].url)!) {
                                phase in
                                switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    case .empty:
                                        ProgressView()
                                    case .failure:
                                        ProgressView()
                                    @unknown default:
                                        fatalError()
                                }
                            }
                        }
                        Text(album.name)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .font(.system(size: 10))
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            .offset(x: -36)
                    }
                    .frame(width: 160, height: 55)
                    .background(Color(red: 41/255, green: 41/255, blue: 41/255))
                    .cornerRadius(5)
                }
            }
        })
    }
}
