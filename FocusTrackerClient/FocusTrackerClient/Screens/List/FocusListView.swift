import SwiftUI

struct FocusListViewWrapper: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        FocusListView(viewModel: .init(itemsRepository: ItemsRepository(modelContext: modelContext)))
    }
}

struct FocusListView: View {
    @StateObject var viewModel: FocusListViewModel
    
    @State private var input: String = ""
    @State private var edit: String = ""
    
    var body: some View {
        VStack {
            ForEach(viewModel.items) { item in
                ItemRow(item: item, onChange: { _, newValue in viewModel.update(item: item, with: newValue)})
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Add To-Do item", text: $input)
                    .onSubmit {
                        viewModel.addNewItem(title: input)
                        input = ""
                    }
            }
            .padding(16)
            .background(Color.gray.opacity(0.4))
            .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ItemRow: View {
    
    @State private var input: String = ""
    @State private var debounceTask: Task<Void, Never>?
    
    private let item: FocusItem
    private let onChange: (String, String) -> Void
    
    init(item: FocusItem, onChange: @escaping (String, String) -> Void) {
        self.item = item
        self.onChange = onChange
    }
    
    var body: some View {
        TextField("", text: $input)
            .onAppear { input = item.title }
            .onChange(of: input) { oldValue, newValue in
                debounceTask?.cancel()
                debounceTask = Task { [oldValue, newValue] in
                    try? await Task.sleep(nanoseconds: 2000_000_000)
                    guard !Task.isCancelled else { return }
                    onChange(oldValue, newValue)
                }
            }
    }
}

#if DEBUG
import SwiftData
#Preview {
    FocusListViewWrapper()
        .modelContainer(for: [FocusItemEntity.self])
}
#endif
