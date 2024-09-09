struct Artist: Decodable {
    let genres: [String]?
    let id: String
    let images: [AlbumImage]
    let name: String
    let popularity: Int
    let type: String
}
