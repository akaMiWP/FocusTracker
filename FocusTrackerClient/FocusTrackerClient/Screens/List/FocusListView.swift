import SwiftUI

struct FocusListViewWrapper: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        FocusListView(viewModel: .init(itemsRepository: ItemsRepository(modelContext: modelContext)))
    }
}

struct FocusListView: View {
    @StateObject var viewModel: FocusListViewModel
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                ItemRow(
                    viewModel: viewModel,
                    item: item,
                    isPresented: $isPresented
                )
            }
            .onDelete(perform: remove(at:))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $isPresented) {
            FocusItemSheetView(viewModel: viewModel, isPresented: $isPresented)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { isPresented.toggle() }) {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .onChange(of: isPresented) { _, isPresented in
            guard !isPresented else { return }
            viewModel.selectedItem = nil
        }
    }
}

private extension FocusListView {
    func remove(at offsets: IndexSet) {
        viewModel.remove(at: offsets)
    }
}

struct ItemRow: View {
    @Binding private var isPresented: Bool
    @ObservedObject var viewModel: FocusListViewModel
    
    private let item: FocusItem
    
    init(
        viewModel: FocusListViewModel,
        item: FocusItem,
        isPresented: Binding<Bool>,
    ) {
        self.viewModel = viewModel
        self.item = item
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.title).font(.body)
            HStack {
                Text("duration: ")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                Text("\(item.duration)")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                Spacer()
            }
            
            if let tag = item.tag {
                HStack {
                    Text("tags: ")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    Text(tag)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }
        }
        .onTapGesture {
            viewModel.selectedItem = item
            isPresented.toggle()
        }
    }
}

struct FocusItemSheetView: View {
    
    @State private var title: String = ""
    @State private var duration: String = ""
    @State private var tag: String = ""
    
    @ObservedObject var viewModel: FocusListViewModel
    @Binding var isPresented: Bool
    
    init(
        title: String = "",
        duration: String = "",
        tag: String = "",
        viewModel: FocusListViewModel,
        isPresented: Binding<Bool>
    ) {
        self.title = title
        self.duration = duration
        self.tag = tag
        self.viewModel = viewModel
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Focus Item")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    let item: FocusItem = .init(title: title, tag: tag, duration: Int(duration) ?? 0)
                    viewModel.addNewItem(item: item)
                    isPresented = false
                }) {
                    Text("Done")
                }
            }
            
            HStack {
                Text("Title:")
                    .fontWeight(.medium)
                
                TextField("Enter a title", text: $title)
            }
            HStack {
                Text("Duration:")
                    .fontWeight(.medium)
                
                TextField("Enter a duration", text: $duration)
            }
            HStack {
                Text("Tag:")
                    .fontWeight(.medium)
                
                TextField("Enter a tag", text: $tag)
            }
            
            Spacer()
        }
        .padding(16)
        .onAppear {
            guard let selectedItem = viewModel.selectedItem else { return }
            title = selectedItem.title
            duration = String(selectedItem.duration)
            selectedItem.tag.map { tag = $0 }
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
