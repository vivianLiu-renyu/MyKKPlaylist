import SwiftUI



struct HomeView: View {
    var playlistData = [
        PlaylistData(playlistName: "Playlist APlaylist 你好啊我很好哇哈哈哈", curatorName: "Artist A", album: "Tata"),
        PlaylistData(playlistName: "Playlist B", curatorName: "Artist B", album: "Tata"),
        PlaylistData(playlistName: "Playlist C", curatorName: "Artist C", album: "Tata"),
        PlaylistData(playlistName: "Playlist D", curatorName: "Artist D", album: "Tata"),
        PlaylistData(playlistName: "Playlist E", curatorName: "Artist E", album: "Tata"),
        PlaylistData(playlistName: "Playlist SKFJGTITYIMBJIJ<N>OK>UOYK>M", curatorName: "Artist A", album: "Tata"),
        PlaylistData(playlistName: "Playlist 你好啊我很好哇哈哈哈", curatorName: "Artist 此我才不告訴你我叫什麼名字", album: "Tata"),
        PlaylistData(playlistName: "Song Name A", curatorName: "Artist 猜猜看", album: "Tata"),
        PlaylistData(playlistName: "Song Name A", curatorName: "Artist 好想出去玩", album: "Tata"),
        PlaylistData(playlistName: "Playlist 歌曲名吧打錯字", curatorName: "Artist 耶一  yayaya ", album: "Tata"),
    ]
    
    var albumData = API().getNewAlbums(territory: "TW", offset: 0, limit: 10)
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionView(sectionTitle: "Playlist Set 1")) {
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
                
                Section(header: SectionView(sectionTitle: "Playlist Set 2")) {
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

struct SectionView: View {
    var sectionTitle: String
    var body: some View {
        HStack(alignment: .center) {
            Text(sectionTitle).font(.system(size: 30))
            Spacer()
            Button(action: {}) {
                Text("More")
            }
        }
    }
}

struct PlaylistSet1: View {
    @State var album: AlbumData
    var position: Int
    var songData = [
        SongData(songName: "Playlist SKFJGTITYIMBJIJ<N>OK>UOYK>M", artistName: "Artist A", album: "Image"),
        SongData(songName: "Playlist 你好啊我很好哇哈哈哈", artistName: "Artist 此我才不告訴你我叫什麼名字", album: "Image"),
        SongData(songName: "Song Name A", artistName: "Artist 猜猜看", album: "Image"),
        SongData(songName: "Song Name A", artistName: "Artist 好想出去玩", album: "Image"),
        SongData(songName: "Playlist 歌曲名吧打錯字", artistName: "Artist 耶一  yayaya ", album: "Image"),
    ]
    
    var body: some View {
        NavigationButton(destination: PlaylistView(playlistName: album.albumName, songData: songData)) {
            VStack(alignment: .center) {
                Image(uiImage: album.albumImage)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .cornerRadius(15.0)
            
                Text(album.albumName)
                    .color(.primary)
                    .font(.system(size: 25))
                    .multilineTextAlignment(.center)
                    .frame(width: 150.0)
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
            NavigationButton(destination: PlaylistView(playlistName: playlist.playlistName)) {
                HStack {
                    Image(playlist.album)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(15.0)
                        .accessibility(identifier: "Playlist Image \(position)")
                    
                    VStack(alignment: .leading) {
                        Text(playlist.playlistName)
                            .font(.system(size: 25))
                            .id("Playlist Name \(position)")
                
                        HStack {
                            Image(playlist.album)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .accessibility(identifier: "Curator Image \(position)")
                        
                            Text(playlist.curatorName)
                                .font(.system(size: 20))
                                .padding(.top, 5.0)
                                .accessibility(identifier: "Curator Name \(position)")
                        }
                    }
                    .padding(.trailing, 10.0)
                }
                .frame(height: 125.0)
                .accessibility(identifier: "Playlist \(position)")
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
