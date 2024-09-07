import SwiftUI

struct Album {
    let id: String
    let name: String
    let artist: String
    let image: String
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .toolbarBackground(
                    .black,
                    for: .tabBar)
            HomeView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .toolbarBackground(
                    .black,
                    for: .tabBar)
            HomeView()
                .tabItem {
                    Label("Library", systemImage: "music.note.house.fill")
                }
                .toolbarBackground(
                    .black,
                    for: .tabBar)
        }.accentColor(.white)
    }
}

#Preview {
    ContentView()
}

struct FilterView: View {
    var mediaFilters = ["All", "Music", "Podcasts", "Audiobooks", "Courses"]
    @State var selectedMediaFilter = "All"

    var gridLayout: [GridItem] = [
        GridItem(.fixed(110)),
    ]

    var body: some View {
        HStack {
            Spacer(minLength: 5)
            Circle()
                .frame(width: 32, height: 32)
                .foregroundStyle(.white)
            ScrollView(.horizontal) {
                LazyHGrid(rows: gridLayout) {
                    ForEach(mediaFilters, id: \.self) {
                        media in
                        Text(media)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(selectedMediaFilter == media ? .green : Color(red: 41/255, green: 41/255, blue: 41/255))
                            .foregroundStyle(.white)
                            .cornerRadius(20)
                            .padding(4)
                            .onTapGesture {
                                selectedMediaFilter = media
                            }
                    }
                }
            }.scrollIndicators(.hidden)
        }.frame(height: 70)
            .padding(.leading, 15)
    }
}

struct AlbumGridView: View {
    @State var albums: [Album]

    var gridLayout: [GridItem] = [
        GridItem(.fixed(180)),
        GridItem(.fixed(180)),
    ]

    var body: some View {
        LazyVGrid(columns: gridLayout, content: {
            ForEach(albums, id: \.id) {
                album in
                HStack {
                    CacheAsyncImage(url: URL(string: album.image)!) {
                        phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                                .offset(x: -20)
                        case .empty:
                            ProgressView()
                        case .failure:
                            ProgressView()
                        @unknown default:
                            fatalError()
                        }
                    }
                    Text(album.name)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .font(.system(size: 12))
                        .offset(x: -40, y: 0)
                }
                .frame(height: 55)
                .background(Color(red: 41/255, green: 41/255, blue: 41/255))
                .cornerRadius(5)
            }
        })
    }
}

struct HomeViewTitle: View {
    @State var title: String

    var body: some View {
        Text(title)
            .fontWeight(.bold)
            .font(.system(size: 24))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
            .padding(.top, 30)
    }
}

struct AlbumHGridView: View {
    @State var albums: [Album]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(albums, id: \.id) {
                    album in
                    VStack {
                        CacheAsyncImage(url: URL(string: album.image)!) {
                            phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90)
                            case .empty:
                                ProgressView()
                            case .failure:
                                ProgressView()
                            @unknown default:
                                fatalError()
                            }
                        }

                        Text(album.name)
                            .offset(x: -10, y: -10)
                            .foregroundColor(.white)
                    }
                }
            }
        }.scrollIndicators(.hidden)
            .offset(x: 14)
    }
}

struct LargeAlbumHGirdView: View {
    @State var albums: [Album]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(albums, id: \.id) {
                    album in
                    VStack {
                        CacheAsyncImage(url: URL(string: album.image)!) {
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

                        VStack {
                            Text(album.name)
                                .offset(x: -40)
                                .foregroundStyle(.white)
                        }.offset(x: 0, y: 25)
                    }.frame(width: 160, height: 200)
                }
            }.offset(x: 5)
        }.scrollIndicators(.hidden)
            .offset(x: 14)
    }
}
