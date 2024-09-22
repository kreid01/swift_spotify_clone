import SwiftUI

struct ProfileSideBar: View {
    @Binding var menuOffset: CGFloat
    @State var changeScreenOffset: (_ offset: CGFloat) -> Void

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
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width < -100 {
                        withAnimation {
                            menuOffset = -400
                            changeScreenOffset(0)
                        }
                    } else {
                        withAnimation {
                            menuOffset = -25
                            changeScreenOffset(350)
                        }
                    }
                }
                .onChanged { value in
                    if value.translation.width < 0 {
                        withAnimation {
                            menuOffset = -25 + value.translation.width
                            changeScreenOffset(350 + value.translation.width)
                        }
                    }
                })
        .offset(x: menuOffset)
    }
}

#if DEBUG
struct MSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlayingSongViewModel())
            .environmentObject(PullSongViewModel())
    }
}
#endif
