import SwiftUI

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
