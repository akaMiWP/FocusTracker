import Foundation
import SwiftData

protocol ItemsRepositoryProtocol {
    var focusItemsStream: AsyncStream<[FocusItem]> { get async }
    
    // MARK: - FocusItem
    func add(_ item: FocusItem) async
    func update(_ item: FocusItem) async
    func remove(at offsets: IndexSet) async
    
    // MARK: - FocusSession
    /// when a session is done, stopped, app enter the background or app crash
    func record(_ session: FocusSession) async
    func update(_ session: FocusSession) async
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
}

// MARK: - Focus Item
extension ItemsRepository {
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
    
    func remove(at offsets: IndexSet) async {
        let idsToDelete: [String] = offsets.compactMap { index in
            guard items.indices.contains(index) else { return nil }
            return items[index].id
        }
        guard !idsToDelete.isEmpty else { return }

        let descriptor = FetchDescriptor<FocusItemEntity>(predicate: #Predicate { entity in
            idsToDelete.contains(entity.id)
        })
        if let entities = try? modelContext.fetch(descriptor) {
            for entity in entities {
                modelContext.delete(entity)
            }
            try? modelContext.save()
        }

        let idsSet = Set(idsToDelete)
        items.removeAll { idsSet.contains($0.id) }

        broadcast()
    }
}

// MARK: - Focus Session
extension ItemsRepository {
    func record(_ session: FocusSession) async {
        
    }
    
    func update(_ session: FocusSession) async {
        
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

