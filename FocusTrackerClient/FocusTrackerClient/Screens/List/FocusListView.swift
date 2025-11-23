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
                TextField("Add Focus Item", text: $input)
                    .onSubmit {
                        addNewItem()
                    }
                
                Button(action: { addNewItem()}) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Private
private extension FocusListView {
    func addNewItem() {
        guard !input.isEmpty else { return }
        viewModel.addNewItem(title: input)
        input = ""
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
