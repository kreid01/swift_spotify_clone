
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
