import SwiftUI

struct UpdateLikedAlbum: Encodable {
    let albumId: String
}

protocol DataContainer: Decodable {
    associatedtype DataType: Decodable
    var data: [DataType] { get }
}

class ViewModel<T>: ObservableObject where T: Decodable {
    @Published var data: T?

    func fetch(url: String) {
        guard let url = URL(string: url) else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    self?.data = decodedData
                    print(decodedData)
                }
            } catch {
                print(error)
            }
        }

        task.resume()
    }

    func Like<I>(id: String, url: String, input: I) where I: Encodable {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(input)
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

    func Unlike<I>(id: String, url: String, input: I) where I: Encodable {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(input)
            request.httpBody = jsonData

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
