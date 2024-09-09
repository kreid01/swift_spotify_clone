import SwiftUI

class ViewModel: ObservableObject {
    @Published var data: SpotifyAlbum?
    var id: String

    init(id: String) {
        self.id = id
    }

    func fetch() {
        guard let url = URL(string: "https://api.spotify.com/v1/albums/\(id)") else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer BQD0PCv-XlqPY4jOBpupYqTcEMmEhVe04h9p-kfOYuqy12Am398g2MFQIJWuRUMEHcFhDoOVrY8FvUXTN5ggxgPnnX-eCVTWlT05w7IGG-IfiTs2CbM", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(SpotifyAlbum.self, from: data)
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
