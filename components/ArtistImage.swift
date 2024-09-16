import SwiftUI

struct ArtistImage: View {
    @State var artistId: String
    @State var height: CGFloat
    @State var width: CGFloat

    @StateObject var artistViewModel = ViewModel<Artist>()

    var body: some View {
        HStack {
            if let images = artistViewModel.data?.images {
                CacheAsyncImage(url: URL(string: images[0].url)!) {
                    phase in
                    switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: width, height: height)
                                .cornerRadius(100)
                                .scaledToFill()
                        case .empty:
                            ProgressView()
                        case .failure:
                            ProgressView()
                        @unknown default:
                            fatalError()
                    }
                }
            }
        }.onAppear {
            artistViewModel.fetch(url: "https://api.spotify.com/v1/artists/\(artistId)")
        }
    }
}
