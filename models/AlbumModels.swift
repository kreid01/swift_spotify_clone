struct SpotifyAlbum: Decodable {
    let total_tracks: Int
    let id: String
    let images: [AlbumImage]
    let name: String
    let release_date: String
    let artists: [AlbumArtist]
    let tracks: Tracks
    let copyrights: [Copyright]
}

struct Copyright: Decodable {
    let text: String
    let type: String
}

struct Tracks: Decodable {
    let total: Int
    let items: [Track]
}

struct Track: Decodable {
    let artists: [AlbumArtist]
    let id: String
    let name: String
    let track_number: Int
    let duration_ms: Int
    let uri: String
}

struct AlbumArtist: Decodable {
    let id: String
    let name: String
    let type: String
    let uri: String
}

struct AlbumImage: Decodable {
    let url: String
    let height: Int
    let width: Int
}

struct SearchSpotifyAlbum: Decodable, Identifiable {
    let total_tracks: Int
    let id: String
    let images: [AlbumImage]?
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
