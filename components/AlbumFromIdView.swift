import SwiftUI

struct AlbumFromIdView: View {
    var id: String
    @StateObject var albumViewModel = ViewModel<SpotifyAlbum>()

    var body: some View {
        HStack {
            NavigationLink(destination: LPView(id: id)) {
                Text("")
                VStack {
                    if let album = albumViewModel.data {
                        CacheAsyncImage(url: URL(string: album.images[0].url)!) {
                            phase in
                            switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 110, height: 110)
                                        .background(.white)
                                        .cornerRadius(5)
                                        .scaledToFit()
                                case .empty:
                                    ProgressView()
                                case .failure:
                                    ProgressView()
                                @unknown default:
                                    fatalError()
                            }

                            Text(album.name)
                                .lineLimit(1)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(album.artists[0].name)
                                .lineLimit(1)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }.onAppear {
                albumViewModel.fetch(url: "https://api.spotify.com/v1/albums/\(id)")
            }.frame(height: 160)
        }
    }
}
