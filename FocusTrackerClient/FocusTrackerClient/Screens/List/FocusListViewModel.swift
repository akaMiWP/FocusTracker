import Combine

@MainActor
final class FocusListViewModel: ObservableObject {
    @Published private(set) var items: [FocusItem] = []
    
    private let itemsRepository: ItemsRepositoryProtocol
    private var streamTask: Task<Void, Never>?
    
    init(itemsRepository: ItemsRepositoryProtocol) {
        self.itemsRepository = itemsRepository
        streamTask = Task { [weak self] in
            guard let self else { return }
            for await newItems in await itemsRepository.focusItemsStream {
                self.items = newItems
            }
        }
    }
    
    deinit { streamTask?.cancel() }
    
    func addNewItem(title: String) {
        Task { await itemsRepository.add(.init(title: title, duration: 0)) }
    }
}
