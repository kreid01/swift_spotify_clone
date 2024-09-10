import SwiftUI

struct LargePlaylistHGridView: View {
    @State var featuredPlaylists: [SearchPlaylist]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(0 ..< min(featuredPlaylists.count, 8), id: \.self) { i in
                    let playlist = featuredPlaylists[i]
                    NavigationLink(destination: LPView(id: playlist.id)) {
                        VStack {
                            if let imageUrl = playlist.images?.first?.url {
                                CacheAsyncImage(url: URL(string: imageUrl)!) { phase in
                                    switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 160, height: 160)
                                        case .empty, .failure:
                                            ProgressView()
                                        @unknown default:
                                            fatalError("Unknown CacheAsyncImage phase")
                                    }
                                }
                            }

                            Text(playlist.description)
                                .lineLimit(1)
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                                .frame(width: 160, height: 40)
                                .foregroundColor(.white)
                                .offset(y: 20)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        }
                        .frame(width: 160, height: 200)
                        .padding(.horizontal, 5)
                    }
                }
            }
            .padding(.horizontal, 14)
        }
    }
}
