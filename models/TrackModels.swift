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

struct TrackObjectResult: Decodable {
    let album: TrackObject
    let name: String
    let artists: [TrackArtist]
}

struct TrackObject: Decodable {
    let id: String
    let images: [AlbumImage]?
    let name: String
}
