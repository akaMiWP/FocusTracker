import Foundation
import SwiftData

protocol ItemsRepositoryProtocol {
    var focusItemsStream: AsyncStream<[FocusItem]> { get async }
    
    func add(_ item: FocusItem) async
    func update(_ item: FocusItem) async
}

@MainActor
final class ItemsRepository: ItemsRepositoryProtocol {
    private var items: [FocusItem] = []
    private var continuations: [AsyncStream<[FocusItem]>.Continuation] = []
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task { await loadInitial() }
    }

    var focusItemsStream: AsyncStream<[FocusItem]> {
        AsyncStream { continuation in
            // Store continuation so we can push updates
            continuations.append(continuation)

            // Yield the current snapshot immediately
            continuation.yield(items)
        }
    }

    func add(_ item: FocusItem) async {
        modelContext.insert(FocusItemEntity(item: item))
        try? modelContext.save()
        
        items.append(item)
        broadcast()
    }
    
    func update(_ item: FocusItem) async {
        let id = item.id
        let descriptor = FetchDescriptor<FocusItemEntity>(predicate: #Predicate { $0.id == id })
        guard let managed = try? modelContext.fetch(descriptor).first else { return }
        managed.title = item.title
        managed.tag = item.tag
        managed.duration = item.duration
        
        try? modelContext.save()
        
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx] = item
            broadcast()
        }
    }
}

// MARK: - Private
private extension ItemsRepository {
    func broadcast() {
        for c in continuations {
            c.yield(items)
        }
    }
    
    func loadInitial() async {
        if let entities = try? modelContext.fetch(FetchDescriptor<FocusItemEntity>()) {
            let items = entities.map(FocusItem.init(entity:))
            self.items = items
            broadcast()
        }
    }
}
