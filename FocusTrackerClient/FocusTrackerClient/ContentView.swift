import Combine
import SwiftData
import SwiftUI

struct RootWrapper: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        ContentView(viewModel: .init(itemsRepository: ItemsRepository(modelContext: modelContext)))
    }
}

final class ContentViewModel: ObservableObject {
    let itemsRepository: ItemsRepositoryProtocol
    
    init(itemsRepository: ItemsRepositoryProtocol) {
        self.itemsRepository = itemsRepository
    }
}

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel

    var body: some View {
        TabView {
            Tab("Session", systemImage: "clock") {
                NavigationStack {
                    SessionView(viewModel: .init(itemsRepository: viewModel.itemsRepository))
                        .navigationTitle("Session")
                }
            }
            
            Tab("Items", systemImage: "bag.fill") {
                NavigationStack {
                    FocusListView(viewModel: .init(itemsRepository: viewModel.itemsRepository))
                        .navigationTitle("Items")
                }
            }
            
            Tab("History", systemImage: "folder.fill") {
                NavigationStack {
                    EmptyView()
                        .navigationTitle("History")
                }
            }
        }
    }
}
