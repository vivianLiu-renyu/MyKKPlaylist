import Foundation
import SwiftUI

let ACCESS_TOKEN = getAccessToken()

enum PlaylistType: String {
    case featuredPlaylists = "featured-playlists"
    case newHitsPlaylists = "new-hits-playlists"
}

class API: NSObject {
    
    func getNewAlbums(territory: String, offset: Int = 0, limit: Int = 10) -> [AlbumData] {
        let group = DispatchGroup()
        var albumDatas = [AlbumData]()
        let urll = "https://api.kkbox.com/v1.1/new-release-categories/Cng5IUIQhxb8w1cbsz/albums?limit=\(limit)&offset=\(offset)&territory=TW"

        let url = URL(string: urll)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        group.enter()
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    albumDatas = self.jsonToAlbum(inputJSON: json!)
                    group.leave()
                }
                catch {
                    print(error)
                }
            }
        }
        
        task.resume()
        group.wait()
        return albumDatas
    }
    
    func getNewHitsPlaylists(territory: String, offset: Int = 0, limit: Int = 10) -> [PlaylistData] {
        let group = DispatchGroup()
        var playlistDatas = [PlaylistData]()
        let urll = "https://api.kkbox.com/v1.1/new-hits-playlists?territory=\(territory)&offset=\(offset)&limit=\(limit)"
        
        let url = URL(string: urll)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        group.enter()
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    playlistDatas = self.jsonToPlaylist(inputJSON: json!)
                    group.leave()
                }
                catch {
                    print(error)
                }
            }
        }
        
        task.resume()
        group.wait()
        return playlistDatas
    }
    
    func getAllTerritoryNewHitsPlaylists(offset: Int = 0, limit: Int = 10) -> [PlaylistData] {
        var playlistDatas = [PlaylistData]()

        for terr in ["TW", "SG", "HK", "JP", "MY"] {
            let playlistDatasInTerr = getNewHitsPlaylists(territory: terr)
            for data in playlistDatasInTerr {
                playlistDatas.append(data)
                print(data.playlistID)
            }
        }
        
        return playlistDatas
    }
    
    func getPlaylistTrack(playlistType: PlaylistType, playlistID: String, territory: String = "TW", limit: Int = 500) -> [SongData] {
        let group = DispatchGroup()
        var songDatas = [SongData]()
        let urll = "https://api.kkbox.com/v1.1/\(playlistType.rawValue)/\(playlistID)/tracks?territory=\(territory)&offset=0&limit=\(limit)"
        let url = URL(string: urll)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        group.enter()
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    songDatas = self.jsonToSongTrack(inputJSON: json!)
                    group.leave()
                }
                catch {
                    print(error)
                }
            }
        }
        
        task.resume()
        group.wait()
        return songDatas
    }
    
    
    func jsonToAlbum(inputJSON: [String: Any]) -> [AlbumData] {
        var result = [AlbumData]()
        let group = DispatchGroup()
        for albumData in inputJSON["data"] as! [[String: Any]] {
            let albumID = albumData["id"] as! String
            let albumImageData = albumData["images"] as! [Any]
            let album1000ImageData = albumImageData[2] as! [String: Any]
            let album1000ImageURL = album1000ImageData["url"] as! String
            let albumName = albumData["name"] as! String
            let artistData = albumData["artist"] as! [String: Any]
            let artistName = artistData["name"] as! String
            let artistImageData = artistData["images"] as! [Any]
            let artist300ImageData = artistImageData[1] as! [String: Any]
            let artist300ImageURL = artist300ImageData["url"] as! String
            var album1000Image = UIImage()
            var artist300Image = UIImage()
            
            
            group.enter()
            let AimageData = try! Data(contentsOf: URL(string: album1000ImageURL)!)
            let AdownloadedImage = UIImage(data: AimageData)
            album1000Image = AdownloadedImage!

            let imageData = try! Data(contentsOf: URL(string: artist300ImageURL)!)
            if let downloadedImage = UIImage(data: imageData) {
                artist300Image = downloadedImage
                group.leave()
            }
            
            result.append(AlbumData(albumID: albumID, albumName: albumName, albumImage: album1000Image, artistName: artistName, artistImage: artist300Image))

            group.wait()
        }
        
        return result
    }
    
    func jsonToPlaylist(inputJSON: [String: Any]) -> [PlaylistData] {
        var result = [PlaylistData]()
        let group = DispatchGroup()
        for playlistData in inputJSON["data"] as! [[String: Any]] {
            let playlistID = playlistData["id"] as! String
            let playlistImageData = playlistData["images"] as! [Any]
            let playlist1000ImageData = playlistImageData[2] as! [String: Any]
            let playlist1000ImageURL = playlist1000ImageData["url"] as! String
            let playlistName = playlistData["title"] as! String
            let curatorData = playlistData["owner"] as! [String: Any]
            let curatorName = curatorData["name"] as! String
            let curatorImageData = curatorData["images"] as! [Any]
            let curator300ImageData = curatorImageData[2] as! [String: Any]
            let curator300ImageURL = curator300ImageData["url"] as! String
            var playlist1000Image = UIImage()
            var curator300Image = UIImage()
            
            
            group.enter()
            let AimageData = try! Data(contentsOf: URL(string: playlist1000ImageURL)!)
            let AdownloadedImage = UIImage(data: AimageData)
            playlist1000Image = AdownloadedImage!
            
            let imageData = try! Data(contentsOf: URL(string: curator300ImageURL)!)
            if let downloadedImage = UIImage(data: imageData) {
                curator300Image = downloadedImage
                group.leave()
            }
            
            result.append(PlaylistData(playlistID: playlistID, playlistName: playlistName, playlistImage: playlist1000Image, curatorName: curatorName, curatorImage: curator300Image))

            group.wait()
        }
        
        return result
    }
    
    func jsonToSongTrack(inputJSON: [String: Any]) -> [SongData] {
        var result = [SongData]()
        let group = DispatchGroup()
        for songData in inputJSON["data"] as! [[String: Any]] {
            let songID = songData["id"] as! String
            let songName = songData["name"] as! String
            let songDuration = songData["duration"] as! Int

            let albumData = songData["album"] as! [String: Any]
            let albumImageData = albumData["images"] as! [Any]
            let album1000ImageData = albumImageData[2] as! [String: Any]
            let album1000ImageURL = album1000ImageData["url"] as! String
            
            
            let artistData = albumData["artist"] as! [String: Any]
            let artistName = artistData["name"] as! String
            let artistImageData = artistData["images"] as! [Any]
            let artist300ImageData = artistImageData[1] as! [String: Any]
            let artist300ImageURL = artist300ImageData["url"] as! String
            
            var album1000Image = UIImage()
            var artist300Image = UIImage()
            
            
            group.enter()
            let AimageData = try! Data(contentsOf: URL(string: album1000ImageURL)!)
            let AdownloadedImage = UIImage(data: AimageData)
            album1000Image = AdownloadedImage!
            
            let imageData = try! Data(contentsOf: URL(string: artist300ImageURL)!)
            if let downloadedImage = UIImage(data: imageData) {
                artist300Image = downloadedImage
                group.leave()
            }
            
            result.append(SongData(songName: songName, artistName: artistName, albumImage: album1000Image))
            
            group.wait()
        }
        
        return result
    }
}

public func getAccessToken() -> String {
    var accessToken = String()
    
    if let path = Bundle.main.path(forResource: "accessToken", ofType: "json") {
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            //try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
            if let jsonResult = json as? Dictionary<String, AnyObject> {
                accessToken = jsonResult["access_token"] as! String
            }
            
            
        } catch let error {
            print("parse error: \(error.localizedDescription)")
        }
    }
    return accessToken
}
