import SwiftUI

struct ArtistFromIdView: View {
    var id: String
    @StateObject var artistViewModel = ViewModel<Artist>()

    var body: some View {
        HStack {
            NavigationLink(destination: ArtistView(id: id)) {
                Text("")
                VStack {
                    if let artist = artistViewModel.data {
                        CacheAsyncImage(url: URL(string: artist.images?[0].url ?? "")!) {
                            phase in
                            switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 110, height: 110)
                                        .background(.white)
                                        .cornerRadius(60)
                                        .scaledToFit()
                                case .empty:
                                    ProgressView()
                                case .failure:
                                    ProgressView()
                                @unknown default:
                                    fatalError()
                            }

                            Text(artist.name)
                                .lineLimit(1)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Artist")
                                .lineLimit(1)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }.onAppear {
                artistViewModel.fetch(url: "https://api.spotify.com/v1/artists/\(id)")
            }
        }
    }
}
