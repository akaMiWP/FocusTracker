import Combine
import Foundation

@MainActor
final class FocusListViewModel: ObservableObject {
    @Published private(set) var items: [FocusItem] = []
    @Published var selectedItem: FocusItem? = nil
    
    private let itemsRepository: ItemsRepositoryProtocol
    private var streamTask: Task<Void, Never>?
    private var selectedItemTask: Task<Void, Never>?
    
    init(itemsRepository: ItemsRepositoryProtocol) {
        self.itemsRepository = itemsRepository
        streamTask = Task { [weak self] in
            guard let self else { return }
            for await newItems in await itemsRepository.focusItemsStream {
                self.items = newItems
            }
        }
        selectedItemTask = Task { [weak self] in
            guard let self else { return }
            for await selectedItem in $selectedItem.values {
                if let selectedItem {
                    await itemsRepository.save(key: .focusItemID, value: selectedItem.id)
                }
            }
        }
    }
    
    deinit { streamTask?.cancel() }
    
    func addNewItem(item: FocusItem) {
        Task { await itemsRepository.add(item) }
    }
    
    func update(item: FocusItem, title: String, tag: String, duration: Int) {
        Task { await itemsRepository.update(item.with(title: title)) }
    }
    
    func remove(at offsets: IndexSet) {
        Task { await itemsRepository.remove(at: offsets) }
    }
}
