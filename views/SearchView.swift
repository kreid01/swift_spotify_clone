import Foundation
import SwiftUI

struct SearchView: View {
    @State var search: String = ""

    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .padding(.leading, 20)
                    .foregroundStyle(.white)
                Text("Search").foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                Spacer()
                Image(systemName: "camera")
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
            }

            TextField("", text: $search).frame(height: 45)
                .background(.white)
                .cornerRadius(5)
                .padding(.horizontal, 15)
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 32)
                        Text("What do you want to listen to?")
                            .padding(.leading, 8)
                            .foregroundStyle(.gray)
                        Spacer()
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
