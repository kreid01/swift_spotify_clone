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
                                        .cornerRadius(5)
                                        .scaledToFit()
                                case .empty:
                                    ProgressView()
                                case .failure:
                                    ProgressView()
                                @unknown default:
                                    fatalError()
                            }
                        }
                        VStack {
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
            }
        }
    }
}

#if DEBUG
struct UIView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlayingSongViewModel())
    }
}
#endif
