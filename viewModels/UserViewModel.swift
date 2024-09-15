import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var data: User?

    func fetch() {
        guard let url = URL(string: "http://localhost:8080/users/1") else {
            return
        }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(UserResult.self, from: data)
                DispatchQueue.main.async {
                    self?.data = decodedData.data
                    print(data)
                }
            } catch {
                print(error)
            }
        }

        task.resume()
    }
}
