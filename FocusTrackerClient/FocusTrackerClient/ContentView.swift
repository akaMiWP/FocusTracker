// 

import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        FocusListViewWrapper()
            .modelContainer(for: [FocusItemEntity.self])
    }
}

#Preview {
    ContentView()
}
