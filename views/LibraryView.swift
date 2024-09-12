import SwiftUI

struct LibraryView: View {
    var gridLayout: [GridItem] = [
        GridItem(.fixed(120)),
        GridItem(.fixed(120)),
        GridItem(.fixed(120)),
    ]

    var mediaFilters = ["Playlists", "Podcasts and courses", "Albums", "Artists", "Downloaded"]
    var selectedMediaFilter = ""

    @State var screenOffsetX: CGFloat = 0
    @State var opacity: Double = 1
    @State var menuOffsetX: CGFloat = -400

    var body: some View {
        NavigationView {
            ZStack {
                ProfileSideBar(menuOffset: $menuOffsetX)
                VStack {
                    HStack {
                        Circle()
                            .frame(width: 32, height: 32)
                            .padding(.leading, 20)
                            .foregroundStyle(.white)
                            .onTapGesture {
                                withAnimation {
                                    menuOffsetX = -25
                                    screenOffsetX = 350
                                    opacity = 0.3
                                }
                            }
                        Text("Your Library")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
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
                .offset(x: screenOffsetX)
                .opacity(opacity)
                .background(Color(red: 25/255, green: 25/255, blue: 25/255))
                .onTapGesture {
                    withAnimation {
                        menuOffsetX = -400
                        screenOffsetX = 0
                        opacity = 1
                    }
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}

struct ProfileSideBar: View {
    @Binding var menuOffset: CGFloat

    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.white)
                VStack {
                    Text("You")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    Text("View profile")
                        .foregroundStyle(.white)
                        .font(.system(size: 12))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.leading, 20)
            .padding(.bottom, 15)

            Divider()

            VStack {
                HStack {
                    Image(systemName: "bolt")
                    Text("Whats new")
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.vertical, 10)
                HStack {
                    Image(systemName: "clock")
                    Text("Litening history")
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.vertical, 10)
                HStack {
                    Image(systemName: "gear")
                    Text("Settings and privacy")
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.vertical, 10)
            }.foregroundStyle(.white)
                .padding(.leading, 20)

            Spacer()
        }
        .frame(width: 350)
        .background(.gray)
        .zIndex(5)
        .offset(x: menuOffset)
    }
}
