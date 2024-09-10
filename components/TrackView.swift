import SwiftUI

struct TrackView: View {
    @State var track: SearchTrack
    @State var index: Int
    @StateObject var trackViewModel = SingleTrackViewModel()

    var body: some View {
        HStack {
            Text(String(index + 1))
                .foregroundStyle(.white)

            if let image = trackViewModel.data?.album.images {
                CacheAsyncImage(url: URL(string: image[0].url)!) {
                    phase in
                    switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                        case .empty:
                            ProgressView()
                        case .failure:
                            ProgressView()
                        @unknown default:
                            fatalError()
                    }
                }
            }
            Text(track.name)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .font(.system(size: 14))
                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .frame(width: 200)
                .offset(x: -15)
            Spacer()
            Image(systemName: "ellipsis")
                .foregroundStyle(.gray)
        }.onAppear {
            trackViewModel.fetch(id: track.id)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 8)
        .frame(height: 70)
    }
}
