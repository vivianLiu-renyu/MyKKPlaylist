import SwiftUI

struct SortMenuView: View {
    @State private var selection = 1
    var body: some View {
        ZStack {
            Spacer()
            Picker(selection: $selection, label: Text("Zeige Deteils")) {
                Text("Schmelzpunkt").tag(1)
                Text("Instrumentelle Analytik").tag(2)
            }
        }
    }
}

#if DEBUG
struct SortMenuView_Previews : PreviewProvider {
    static var previews: some View {
        SortMenuView()
    }
}
#endif

