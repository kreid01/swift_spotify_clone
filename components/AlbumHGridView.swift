import SwiftUI

struct AlbumHGridView: View {
    @State var albums: [SearchSpotifyAlbum]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(albums.prefix(upTo: 8), id: \.id) {
                    album in
                    NavigationLink(destination: LPView(id: album.id)) {
                        VStack {
                            if let images = album.images {
                                CacheAsyncImage(url: URL(string: images[0].url)!) {
                                    phase in
                                    switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 90)
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
                                .offset(y: -10)
                                .font(.system(size: 10))
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                                .frame(width: 90)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }.scrollIndicators(.hidden)
            .offset(x: 14)
    }
}

#Preview {
    HomeView()
}
