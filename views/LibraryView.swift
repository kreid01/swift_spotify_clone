import SwiftUI

struct LibraryView: View {
    var gridLayout: [GridItem] = [
        GridItem(.fixed(120)),
        GridItem(.fixed(120)),
        GridItem(.fixed(120)),
    ]

    var mediaFilters = ["Playlists", "Podcasts and courses", "Albums", "Artists", "Downloaded"]
    var selectedMediaFilter = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .padding(.leading, 20)
                        .foregroundStyle(.white)
                    Text("Your Library").foregroundStyle(.white)
                        .fontWeight(.bold)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.asciiCapable)
                        .font(.system(size: 24))
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }

                Filters(mediaFilters: mediaFilters, selectedMediaFilter: selectedMediaFilter)
                    .padding(.leading, 10)

                ScrollView {
                    LazyVGrid(columns: gridLayout) {
                        ForEach(0 ..< 20) { _ in
                            VStack {
                                HStack {}
                                    .frame(width: 110, height: 110)
                                    .background(.white)
                                    .cornerRadius(5)
                                Text("sacue")
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .offset(x: 5)
                                Text("sacue")
                                    .foregroundStyle(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .offset(x: 5, y: -5)
                            }
                        }
                    }
                }
            }
            .background(Color(red: 25/255, green: 25/255, blue: 25/255))
        }
    }
}

#Preview {
    LikedSongsView()
}

