import Foundation
import SwiftUI

struct PlaylistResult: Decodable {
    var playlists: PlaylistItemsResult
}

struct PlaylistItemsResult: Decodable {
    let items: [SearchPlaylist]
}

struct SearchPlaylist: Decodable {
    let collaborative: Bool
    let description: String
    let id: String
    let images: [PlaylistImage]?
}

struct PlaylistImage: Decodable {
    let url: String
}

class PlaylistViewModel: ObservableObject {
    @Published var data: PlaylistResult?

    func search(artist: String) {
        guard let url = URL(string: "https://api.spotify.com/v1/search?q=artist:\(artist)&type=playlist") else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(PlaylistResult.self, from: data)
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
