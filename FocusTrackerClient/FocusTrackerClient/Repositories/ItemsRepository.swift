protocol ItemsRepositoryProtocol {
    var focusItemsStream: AsyncStream<[FocusItem]> { get async }
    
    func add(_ item: FocusItem) async
    func update(_ item: FocusItem) async
}

actor ItemsRepository: ItemsRepositoryProtocol {
    private var items: [FocusItem] = []
    private var continuations: [AsyncStream<[FocusItem]>.Continuation] = []

    var focusItemsStream: AsyncStream<[FocusItem]> {
        AsyncStream { continuation in
            // Store continuation so we can push updates
            continuations.append(continuation)

            // Yield the current snapshot immediately
            continuation.yield(items)
        }
    }

    func add(_ item: FocusItem) async {
        items.append(item)
        broadcast()
    }
    
    func update(_ item: FocusItem) async {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx] = item
            broadcast()
        }
    }

    private func broadcast() {
        for c in continuations {
            c.yield(items)
        }
    }
}
