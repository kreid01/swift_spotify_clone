import Foundation
import SwiftUI

struct TracksResult: Decodable {
    var tracks: TrackItemsResult
}

struct TrackItemsResult: Decodable {
    let items: [SearchTrack]
}

struct SearchTrack: Decodable {
    let name: String
    let artists: [TrackArtist]
    let duration_ms: Int
    let id: String
    let popularity: Int
    let images: [AlbumImage]?
    let type: String
}

struct TrackArtist: Decodable, Hashable, Identifiable {
    let name: String
    let id: String
}

class TrackViewModel: ObservableObject {
    @Published var data: TracksResult?

    func search(artist: String) {
        guard let url = URL(string: "https://api.spotify.com/v1/search?q=artist:\(artist)&type=track&limit=50") else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(TracksResult.self, from: data)
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
