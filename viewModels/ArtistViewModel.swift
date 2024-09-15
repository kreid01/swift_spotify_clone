import SwiftUI

struct UpdateFollowedArtistInput: Encodable {
    let artistId: String
}

class ArtistViewModel: ObservableObject {
    @Published var data: Artist?

    func fetch(id: String) {
        guard let url = URL(string: "https://api.spotify.com/v1/artists/\(id)") else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(Artist.self, from: data)
                DispatchQueue.main.async {
                    self?.data = decodedData
                }
            } catch {
                print(error)
            }
        }

        task.resume()
    }

    func FollowArtist(id: String) {
        guard let url = URL(string: "http://localhost:8080/users/followed-artists/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(UpdateFollowedArtistInput(artistId: id))
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

    func UnFollowArtists(id: String) {
        guard let url = URL(string: "http://localhost:8080/users/followed-artists/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(UpdateFollowedArtistInput(artistId: id))
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
}
