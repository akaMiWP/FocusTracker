// 

import SwiftData
import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            Tab("Items", image: "") {
                NavigationStack {
                    FocusListViewWrapper()
                        .modelContainer(for: [FocusItemEntity.self])
                        .navigationTitle("Items")
                }
            }
            
            Tab("Session", image: "") {
                NavigationStack {
                    EmptyView()
                        .navigationTitle("Session")
                }
            }
            
            Tab("History", image: "") {
                NavigationStack {
                    EmptyView()
                        .navigationTitle("History")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
