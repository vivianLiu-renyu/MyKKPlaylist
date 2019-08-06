import SwiftUI

struct HomeView: View {
    var playlistData = API().getAllTerritoryNewHitsPlaylists()
    var albumData = API().getNewAlbums(territory: "TW", offset: 0, limit: 10)
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionViewWithMoreButton(sectionTitle: "New Album")) {
                    ScrollView(showsHorizontalIndicator: false, showsVerticalIndicator: false) {
                        HStack(alignment: .center, spacing: 10.0) {
                            ForEach(0..<albumData.count) { index in
                                PlaylistSet1(album: self.albumData[index], position: index)
                            }
                        }
                        .padding([.top, .bottom], 10.0)
                    }
                    .frame(height: 180)
                }
                .padding([.top,.bottom], 5.0)
                
                Section(header: SectionView(sectionTitle: "New Hits Playlist")) {
                    ForEach(0..<playlistData.count) { index in
                        PlaylistSet2(playlist: self.playlistData[index], position: index)
                    }
                }
                .padding([.top,.bottom], 5.0)
            }
            .navigationBarTitle(Text("Home"), displayMode: .large)
        }
    }
}

struct SectionViewWithMoreButton: View {
    var sectionTitle: String
    var body: some View {
        HStack(alignment: .center) {
            Text(sectionTitle).font(.system(size: 25))
            Spacer()
            Button(action: {}) {
                Text("More")
            }
        }
    }
}

struct SectionView: View {
    var sectionTitle: String
    var body: some View {
        HStack(alignment: .center) {
            Text(sectionTitle).font(.system(size: 25))
        }
    }
}

struct PlaylistSet1: View {
    var album: AlbumData
    var position: Int
    
    var body: some View {
        NavigationButton(destination: PlaylistView(playlistName: album.albumName, playlistID: album.albumID, playlistType: .newHitsPlaylists)) {
            VStack(alignment: .center) {
                Image(uiImage: album.albumImage)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .cornerRadius(15.0)
                Text(album.albumName)
                    .color(.primary)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                    .frame(width: 150.0)
                    .padding(.top, 8.0)
                    .accessibility(identifier: "New Album Name \(position)")
            }
            .accessibility(identifier: "New Album \(position)")
        }
    }
}

struct PlaylistSet2: View {
    var playlist: PlaylistData
    var position: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationButton(destination: PlaylistView(playlistName: playlist.playlistName,playlistID: playlist.playlistID, playlistType: .newHitsPlaylists)) {
                HStack {
                    Image(uiImage: playlist.playlistImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(15.0)
                        .accessibility(identifier: "New Hits Playlist Image \(position)")
                    
                    VStack(alignment: .leading) {
                        Text(playlist.playlistName)
                            .font(.system(size: 20))
                            .accessibility(identifier: "New Hits Playlist Name \(position)")
                
                        HStack {
                            Image(uiImage: playlist.curatorImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .accessibility(identifier: "Curator Image \(position)")
                        
                            Text(playlist.curatorName)
                                .font(.system(size: 14))
                                .padding(.top, 8.0)
                                .accessibility(identifier: "Curator Name \(position)")
                        }
                    }
                    .padding(.trailing, 15.0)
                }
                .frame(height: 125.0)
                .accessibility(identifier: "New Hits Playlist \(position)")
            }
        }
    }
}

#if DEBUG
struct HomeView_Previews : PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
