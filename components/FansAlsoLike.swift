import SwiftUI

struct FansAlsoLike: View {
    @State var artists: [TrackArtist]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(artists) { artist in
                    NavigationLink(destination: ArtistView(id: artist.id)) {
                        VStack {
                            ArtistImage(artistId: artist.id, height: 160, width: 160)
                            Text(artist.name)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                                .frame(width: 140, height: 40, alignment: .top)
                                .foregroundColor(.white)
                                .offset(y: 30)
                        }.offset(x: 0, y: 25)
                    }.frame(width: 160, height: 220)
                }
            }
        }.scrollIndicators(.hidden)
            .padding(.trailing, 30)
            .offset(x: 14, y: -30)
    }
}
