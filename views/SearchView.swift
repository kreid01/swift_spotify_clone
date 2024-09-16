import Foundation
import SwiftUI

struct SearchView: View {
    @State var search: String = ""
    @FocusState private var searchFieldIsFocused;
    @State var searching: Bool = false
    @StateObject var searchViewModel = ViewModel<AlbumResult>()
    
    var body: some View {
        NavigationView {
            if searching {
                VStack {
                    VStack {
                        HStack {
                            TextField("", text: $search).frame(height: 30)
                                .focused($searchFieldIsFocused)
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                                .background(Color(red: 53/255, green: 53/255, blue: 53/255))
                                .textInputAutocapitalization(.never)
                                .keyboardType(.asciiCapable)
                                .onChange(of: search, perform: { value in
                                    if value != "" {
                                        searchViewModel.fetch(url: "https://api.spotify.com/v1/search?q=artist:\(value)&type=album")
                                    }
                                })
                                .padding(10)
                                .overlay {
                                    if search == "" {
                                        HStack {
                                            Image(systemName: "magnifyingglass")
                                                .foregroundColor(.gray)
                                                .padding(.leading, 20)
                                            Text("What do you want to listen to?")
                                                .foregroundStyle(.gray)
                                            Spacer()
                                        }
                                    }
                                }
                            
                            Text("Cancel")
                                .foregroundStyle(.white)
                                .padding(.trailing, 15)
                                .onTapGesture {
                                    self.searching = false
                                    self.search = ""
                                }
                        }
                        .padding(.bottom, 10)
                        .background(Color(red: 31/225, green: 31/255, blue: 31/255))
                        
                        Text("Recent searches")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                        
                        ScrollView {
                            if let albums = searchViewModel.data?.albums {
                                ForEach(albums.items) { item in
                                    NavigationLink(destination: LPView(id: item.id)) {
                                        HStack {
                                            if let imageUrl = item.images?.first?.url {
                                                CacheAsyncImage(url: URL(string: imageUrl)!) { phase in
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
                                                            fatalError("Unknown image loading phase")
                                                    }
                                                }
                                            } else {
                                                ProgressView()
                                            }
                                            
                                            VStack {
                                                Text(item.name)
                                                    .lineLimit(1)
                                                    .fontWeight(.bold)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                Text("Album - \(item.artists[0].name)")
                                                    .lineLimit(1)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }.foregroundStyle(.white)
                                                .offset(x: -10)
                                            
                                            Image(systemName: "xmark")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 20))
                                                .padding(.trailing, 12)
                                        }.frame(height: 70)
                                            .frame(height: 70)
                                    }
                                }
                            }
                            Text("Clear recent searches")
                                .font(.system(size: 16))
                                .frame(width: 195, height: 40)
                                .background(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white, lineWidth: 1))
                                .foregroundColor(.white)
                        }
                        
                    }.background(Color(red: 25/255, green: 25/255, blue: 25/255))
                }
            } else {
                VStack {
                    HStack {
                        Circle()
                            .frame(width: 32, height: 32)
                            .padding(.leading, 20)
                            .foregroundStyle(.white)
                        Text("Search").foregroundStyle(.white)
                            .fontWeight(.bold)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.asciiCapable)
                            .font(.system(size: 24))
                        Spacer()
                        Image(systemName: "camera")
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                    }
                    
                    ZStack(alignment: .leading) {
                        TextField("", text: $search)
                            .frame(height: 45)
                            .background(Color.white)
                            .cornerRadius(5)
                            .padding(.horizontal, 15)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 32)
                            Text("What do you want to listen to?")
                                .padding(.leading, 8)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 15)
                        .onTapGesture {
                            self.searching = true
                            self.searchFieldIsFocused = true
                        }
                    }
                    
                    ScrollView {
                        SearchViewTitle(title: "Start browsing")
                        StartBroswing()
                        SearchViewTitle(title: "Browse all")
                        BrowseAll()
                    }
                }.background(Color(red: 25/255, green: 25/255, blue: 25/255))
            }
        }
    }
}
    
func getColour(index: Int) -> Color {
    switch index {
        case 0:
            return .pink
        case 1:
            return .green
        case 2:
            return .blue
        case 3:
            return .purple
        case 4:
            return .orange
        default:
            return .indigo
    }
}
    
#Preview {
    SearchView()
}
    
struct SearchViewTitle: View {
    @State var title: String
        
    var body: some View {
        Text(title)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
    }
}
    
struct StartBroswing: View {
    var mediaTypes = ["Music", "Podcasts", "Audiobooks", "Live Events", "Courses"]
        
    var gridLayout: [GridItem] = [
        GridItem(.fixed(180)),
        GridItem(.fixed(180)),
    ]
        
    var body: some View {
        LazyVGrid(columns: gridLayout) {
            ForEach(mediaTypes, id: \.self) {
                type in
                HStack {
                    Text(type)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .padding(.leading, 5)
                        .padding(.bottom, 25)
                    Spacer()
                }
                .frame(width: 170, height: 60)
                .background(getColour(index: mediaTypes.firstIndex(of: type) ?? 1))
                .padding(.vertical, 5)
                .cornerRadius(10)
            }
        }
    }
}

struct BrowseAll: View {
    let spotifyCategories = [
        "Made For You",
        "Charts",
        "New Releases",
        "Discover",
        "Concerts",
        "Podcasts",
        "Mood",
        "Workout",
        "Focus",
        "Chill",
        "Party",
        "Pop",
        "Hip-Hop",
        "Indie",
        "Rock",
        "R&B",
        "Classical",
        "Jazz",
        "Metal",
        "Electronic",
        "Dance",
        "Soul",
        "Reggae",
        "Country",
        "K-Pop",
        "Latin",
        "Afro",
        "Punk",
        "Alternative",
        "Blues",
        "Folk & Acoustic",
        "Ambient",
        "Instrumental",
        "Romance",
        "Travel",
        "Sleep",
        "Cooking",
        "Kids & Family",
    ]

    var gridLayout: [GridItem] = [
        GridItem(.fixed(180)),
        GridItem(.fixed(180)),
    ]

    var body: some View {
        LazyVGrid(columns: gridLayout) {
            ForEach(spotifyCategories, id: \.self) {
                type in
                HStack {
                    Text(type)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .padding(.leading, 5)
                        .padding(.bottom, 35)
                    Spacer()
                }

                .frame(width: 170, height: 80)
                .background(generateRandomColor())
                .padding(.vertical, 5)
            }
        }
    }
}

func generateRandomColor() -> Color {
    let red = Double.random(in: 0...1)
    let green = Double.random(in: 0...1)
    let blue = Double.random(in: 0...1)
    return Color(red: red, green: green, blue: blue)
}
