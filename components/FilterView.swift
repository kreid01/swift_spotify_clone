import SwiftUI

struct FilterView: View {
    var mediaFilters = ["All", "Music", "Podcasts", "Audiobooks", "Courses"]
    var selectedMediaFilter = "All"

    var body: some View {
        HStack {
            Spacer(minLength: 5)
            Circle()
                .frame(width: 32, height: 32)
                .foregroundStyle(.white)
            Filters(mediaFilters: mediaFilters, selectedMediaFilter: selectedMediaFilter)
        }.frame(height: 70)
            .padding(.leading, 15)
    }
}

struct Filters: View {
    @State var mediaFilters: [String]
    @State var selectedMediaFilter: String

    var gridLayout: [GridItem] = [
        GridItem(.fixed(110)),
    ]

    var body: some View {
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
            .frame(height: 70)
    }
}
