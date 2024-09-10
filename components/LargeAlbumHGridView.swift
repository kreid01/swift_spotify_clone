import SwiftUI

struct LargeAlbumHGridView: View {
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
                                            .frame(width: 160, height: 160)
                                            .scaledToFit()
                                    case .empty:
                                        ProgressView()
                                    case .failure:
                                        ProgressView()
                                    @unknown default:
                                        fatalError()
                                    }
                                }
                            }

                            VStack {
                                Text(album.name)
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                                    .frame(width: 160, height: 40, alignment: .top)
                                    .foregroundColor(.white)
                            }.offset(x: 0, y: 25)
                        }.frame(width: 160, height: 200)
                    }
                }
            }.offset(x: 5)
        }.scrollIndicators(.hidden)
            .offset(x: 14)
    }
}

#Preview {
    HomeView()
}
