import SwiftUI

struct UpdateUserLikesInput: Encodable {
    let likeId: String
}

struct UserResult: Decodable {
    let data: User
}

struct User: Decodable {
    let ID: Int
    let name: String
    let likes: [String]
    let followedArtists: [String]
    var likedAlbums: [String]
}

class LikedSongsViewModel: ObservableObject {
    @Published var data: User?

    func LikeSong(id: String) {
        guard let url = URL(string: "http://localhost:8080/users/likes/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(UpdateUserLikesInput(likeId: id))
            request.httpBody = jsonData

            print(jsonData)

            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Failed to send feedback: \(error.localizedDescription)")
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    DispatchQueue.main.async {
                        print("Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                    }
                    return
                }

                DispatchQueue.main.async {
                    print("Feedback sent successfully!")
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                print("Failed to encode feedback")
            }
        }
    }

    func UnLikeSong(id: String) {
        guard let url = URL(string: "http://localhost:8080/users/likes/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(UpdateUserLikesInput(likeId: id))
            request.httpBody = jsonData

            print(jsonData)

            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Failed to send feedback: \(error.localizedDescription)")
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    DispatchQueue.main.async {
                        print("Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                    }
                    return
                }

                DispatchQueue.main.async {
                    print("Feedback sent successfully!")
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                print("Failed to encode feedback")
            }
        }
    }

    func fetch() {
        guard let url = URL(string: "http://localhost:8080/users/1") else {
            return
        }

        var request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(UserResult.self, from: data)
                DispatchQueue.main.async {
                    self?.data = decodedData.data
                }
            } catch {
                print(error)
            }
        }

        task.resume()
    }
}

struct LikedSongsView: View {
    var mediaFilter: [String] = ["Alternative Hip-Hop", "Indie Rock", "Rock", "Metal", "Fast", "Country"]
    var selectedMediaFilter = ""
    @StateObject var likedSongsViewModel: LikedSongsViewModel = .init()

    var body: some View {
        NavigationView {
            VStack {
                HomeViewTitle(title: "Liked Songs")
                Text("2053 songs")
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)

                HStack {
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 5)

                    Spacer()

                    Image(systemName: "shuffle")
                        .frame(width: 50, height: 50)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)

                    Image(systemName: "play.fill")
                        .frame(width: 50, height: 50)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .background(.green)
                        .cornerRadius(30)
                        .padding(.trailing, 25)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)

                Filters(mediaFilters: mediaFilter, selectedMediaFilter: selectedMediaFilter)
                    .padding(.leading, 15)

                ScrollView {
                    HStack {
                        Image(systemName: "plus")
                            .padding(22)
                            .background(Color.gray)
                        Text("Add songs")
                            .frame(minWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: 200, height: 70)
                    .foregroundStyle(.white)
                    if let likedSongs = likedSongsViewModel.data?.likes {
                        ForEach(0 ..< likedSongs.count) { i in
                            TrackViewFromId(id: likedSongs[i]).onTapGesture {}
                        }
                    }
                }
                .refreshable {
                    likedSongsViewModel.fetch()
                }
                .padding(.horizontal, 20)
                .onAppear {
                    likedSongsViewModel.fetch()
                }
            }
            .background(Color(red: 25/255, green: 25/255, blue: 25/255))
        }
    }
}

#Preview {
    LikedSongsView()
}
