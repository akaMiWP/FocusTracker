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
            Tab("Session", image: "") {
                NavigationStack {
                    SessionView(viewModel: .init(itemsRepository: viewModel.itemsRepository))
                        .navigationTitle("Session")
                }
            }
            
            Tab("Session", image: "") {
                NavigationStack {
                    SessionView(viewModel: .init(itemsRepository: viewModel.itemsRepository))
                        .navigationTitle("Session")
                }
            }
            
            Tab("Items", image: "") {
                NavigationStack {
                    FocusListView(viewModel: .init(itemsRepository: viewModel.itemsRepository))
                        .navigationTitle("Items")
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
