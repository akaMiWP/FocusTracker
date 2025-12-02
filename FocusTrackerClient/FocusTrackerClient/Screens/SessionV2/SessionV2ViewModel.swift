//
//  Created by akaMiWP on 1/12/2568 BE.
//  Copyright © 2568 BE. All rights reserved.
    
import Combine

final class SessionV2ViewModel: ObservableObject {
    
    @Published var focusedItem: FocusItem?
    
    private let itemsRepository: ItemsRepositoryProtocol
    private var focusedItemTask: Task<Void, Never>?

    init(itemsRepository: ItemsRepositoryProtocol) {
        self.itemsRepository = itemsRepository
        focusedItemTask = Task { [weak self] in
            guard let self else { return }
            for await item in await itemsRepository.focusedItemStream {
                self.focusedItem = item
            }
        }
    }
}
