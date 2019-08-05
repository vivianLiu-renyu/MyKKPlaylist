import Foundation
import SwiftUI

struct SongData {
    let songName: String
    let artistName: String
    let album: String
}

struct PlaylistData: Decodable {
    let playlistName: String
    let curatorName: String
    let album: String
}

struct AlbumData {
    let albumID: String
    let albumName: String
    let albumImage: UIImage
    let artistName: String
    let artistImage: UIImage
}
