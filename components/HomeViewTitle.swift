import SwiftUI

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
