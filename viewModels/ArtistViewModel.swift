import SwiftUI

class ArtistViewModel: ObservableObject {
    @Published var data: Artist?

    func fetch(id: String) {
        guard let url = URL(string: "https://api.spotify.com/v1/artists/\(id)") else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer BQCLpitg8Nt6cZQNdie60Ws8IHPkxhVoDcGy6ZyGA7tmgIe7To_enW-FPlT34db-S8DzkbFmON--QGaCtZmSBmfmmvR9yELpLfNT044j1R8rCr3Ug1A", forHTTPHeaderField: "Authorization")
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
}
