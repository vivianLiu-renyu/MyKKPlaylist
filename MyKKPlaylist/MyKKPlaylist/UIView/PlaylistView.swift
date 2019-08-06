import SwiftUI

struct PlaylistView : View {
    var playlistName: String
    var playlistID: String
    var playlistType: PlaylistType
    
    var body: some View {
        let songData = API().getPlaylistTrack(playlistType: playlistType, playlistID: playlistID, territory: "TW")
        
        let a = VStack {
            List(songData.identified(by: \.songName)) { data in
                HStack {
                    Image(uiImage: data.albumImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(15.0)
        
                    VStack(alignment: .leading) {
                        Text(data.songName)
                            .font(.system(size: 20))
            
                        Text(data.artistName)
                            .font(.system(size: 15))
                            .padding(.top, 1.0)
                    }
                    .padding(.trailing, 15)
                    .padding([.top, .bottom], 6.0)
                }
            }
        }
        .navigationBarTitle(Text(playlistName),displayMode: .inline)
        .navigationBarItems(trailing: ShowSortMenu())
        
        return a
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
        PlaylistView(playlistName: "Testing", playlistID: "A", playlistType: .featuredPlaylists)
    }
}
#endif
