import Foundation
import SwiftUI

class AppearsOnViewModel: ObservableObject {
    @Published var data: ItemResult?

    func search(id: String) {
        guard let url = URL(string: "https://api.spotify.com/v1/artists/\(id)/albums?limit=50&include_groups=appears_on") else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(ItemResult.self, from: data)
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
