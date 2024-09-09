import Foundation

struct SearchSpotifyAlbum: Decodable, Identifiable {
    let total_tracks: Int
    let id: String
    let images: [AlbumImage]
    let name: String
    let release_date: String
    let artists: [Artist]
}

struct AlbumResult: Decodable {
    var albums: ItemResult
}

struct ItemResult: Decodable {
    let items: [SearchSpotifyAlbum]
}

class SearchViewModel: ObservableObject {
    @Published var data: AlbumResult?

    func search(search: String) {
        guard let url = URL(string: "https://api.spotify.com/v1/search?q=artist:\(search)&type=album") else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer BQCLMDkm6C8eIN6xIeMnu0T2EA51wWFHaTLORjtq88aSzUf0szyIwvOf677l_V0ZisHaRYAZw9LWgwfmEaSYgOUYktA2_guB7h-6DqyIWTPt24Hg7t8", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(AlbumResult.self, from: data)
                DispatchQueue.main.async {
                    self?.data = decodedData
                }
            } catch {
                print(error)
            }
        }

        task.resume()
    }
}
