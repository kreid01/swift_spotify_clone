import SwiftUI

struct PopularReleaseView: View {
    @State var releases: [SearchSpotifyAlbum]

    var body: some View {
        ForEach(releases.prefix(4)) { release in
            if let images = release.images {
                HStack {
                    CacheAsyncImage(url: URL(string: images[0].url)!) {
                        phase in
                        switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80)
                            case .empty:
                                ProgressView()
                            case .failure:
                                ProgressView()
                            @unknown default:
                                fatalError()
                        }
                    }

                    VStack {
                        Text(release.name)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)

                        Text("\(release.release_date.prefix(4)) - Album")
                            .foregroundStyle(.gray)
                            .font(.system(size: 16))
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    }

                    Spacer()
                }
                .padding(.leading, 10)
                .frame(height: 85)
            }
        }
    }
}
