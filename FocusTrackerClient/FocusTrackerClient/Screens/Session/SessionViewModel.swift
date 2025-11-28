import Combine

final class SessionViewModel: ObservableObject {
    @Published var focusedItem: FocusItem?
    private let itemsRepository: ItemsRepositoryProtocol
    private var focusedItemTask: Task<Void, Never>?
    
    init(itemsRepository: ItemsRepositoryProtocol) {
        self.itemsRepository = itemsRepository
        
        focusedItemTask = Task { [weak self] in
            guard let self else { return }
            for await focusedItem in await itemsRepository.focusedItemStream {
                self.focusedItem = focusedItem
            }
        }
    }
}
