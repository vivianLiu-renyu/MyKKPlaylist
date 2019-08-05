import Foundation
import SwiftUI

let ACCESS_TOKEN = getAccessToken()

class API: NSObject {
    
    func getNewAlbums(territory: String, offset: Int, limit: Int) -> [AlbumData] {
        let group = DispatchGroup()
        var playlistDatas = [AlbumData]()
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
                    playlistDatas = self.jsonToAlbum(inputJSON: json!)
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
            
            print(albumData)
            group.wait()
        }
        
        return result
    }
    
    func castToPlaylist(data: [String: AnyObject]) -> [PlaylistData] {
        var result = [PlaylistData]()
        
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
