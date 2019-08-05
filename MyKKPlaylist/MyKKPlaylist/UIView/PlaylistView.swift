import SwiftUI



struct PlaylistView : View {
    var playlistName: String
    var songData = [
        SongData(songName: "Playlist A", artistName: "Artist A", album: "Tata"),
        SongData(songName: "Playlist B", artistName: "Artist B", album: "Tata"),
        SongData(songName: "Playlist C", artistName: "Artist C", album: "Tata"),
        SongData(songName: "Playlist D", artistName: "Artist D", album: "Tata"),
        SongData(songName: "Playlist E", artistName: "Artist E", album: "Tata"),
        SongData(songName: "Playlist SKFJGTITYIMBJIJ<N>OK>UOYK>M", artistName: "Artist A", album: "Tata"),
        SongData(songName: "Playlist 你好啊我很好哇哈哈哈", artistName: "Artist 此我才不告訴你我叫什麼名字", album: "Tata"),
        SongData(songName: "Song Name A", artistName: "Artist 猜猜看", album: "Tata"),
        SongData(songName: "Song Name A", artistName: "Artist 好想出去玩", album: "Tata"),
        SongData(songName: "Playlist 歌曲名吧打錯字", artistName: "Artist 耶一  yayaya ", album: "Tata"),
    ]
    
    var body: some View {
        VStack {
            List(songData.identified(by: \.songName)) { data in
                HStack {
                    Image(data.album)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(15.0)
        
                    VStack(alignment: .leading) {
                        Text(data.songName)
                            .font(.system(size: 25))
            
                        Text(data.artistName)
                            .font(.system(size: 20))
                            .padding(.top, 1.0)
                    }
                    .padding([.top, .bottom, .trailing], 6.0)
                }
            }
        }
        .navigationBarTitle(Text("laylistName"),displayMode: .inline)
        //Button(action: self.sortMenuStatus.toggle, label: Text("Select"))
        .navigationBarItems(trailing: ShowSortMenu())
    }
}

struct ShowSortMenu : View {
    @State private var showActionSheet = false
    private var actionSheet: ActionSheet {
        let button1 = ActionSheet.Button.default(Text("Sort By Name")) {
            self.showActionSheet = false
        }
        let button2 = ActionSheet.Button.default(Text("Sort By Artist")) {
            self.showActionSheet = false
        }
        let button3 = ActionSheet.Button.default(Text("Sort By Date")) {
            self.showActionSheet = false
        }
        let dismissButton = ActionSheet.Button.cancel {
            self.showActionSheet = false
        }
        let buttons = [button1, button2, button3, dismissButton]
        return ActionSheet(title: Text("Sorting option"), message: Text("Choose one sorting type to change songs sorting"), buttons: buttons)
    }

    var body: some View {
        Button(action: {self.showActionSheet = true}) {
            Text("Sort")
        }.presentation(showActionSheet ? actionSheet : nil)
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        PlaylistView(playlistName: "Testing")
    }
}
#endif
