import Foundation
import SwiftData

protocol ItemsRepositoryProtocol {
    var focusItemsStream: AsyncStream<[FocusItem]> { get async }
    var focusedItemStream: AsyncStream<FocusItem?> { get async }
    
    // FocusItem
    func add(_ item: FocusItem) async
    func update(_ item: FocusItem) async
    func remove(at offsets: IndexSet) async
    
    // FocusSession
    func record(_ session: FocusSession) async /// when a session is done, stopped, app enter the background or app crash
    func update(_ session: FocusSession) async
    
    // Generic
    func save<T>(key: UserDefaultKey, value: T?) async
}

@MainActor
final class ItemsRepository: ItemsRepositoryProtocol {

    private let modelContext: ModelContext
    
    // Focus item properties
    private var items: [FocusItem] = []
    private var continuations: [AsyncStream<[FocusItem]>.Continuation] = []
    
    // Focus session properties
    private var focusItem: FocusItem?
    private var focusItemContinuation: AsyncStream<FocusItem?>.Continuation?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task { await loadInitial() }
    }

    func save<T>(key: UserDefaultKey, value: T?) async {
        guard let value else { return }
        UserDefaults.standard.set(value, forKey: key.rawValue)
        
        switch key {
        case .focusItemID:
            guard let value = value as? String else { return }
            focusItem = items.first(where: { $0.id == value }) ?? items.first
            focusItemContinuation?.yield(focusItem)
        }
    }
}

// MARK: - Focus Item
extension ItemsRepository {
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
        
        if focusItem?.id == item.id {
            focusItem = item
            focusItemContinuation?.yield(focusItem)
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
    var focusedItemStream: AsyncStream<FocusItem?> {
        AsyncStream { continuation in
            self.focusItemContinuation = continuation
            continuation.yield(focusItem)
        }
    }
    
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
        guard let entities = try? modelContext.fetch(FetchDescriptor<FocusItemEntity>()) else { return }

        let items = entities.map(FocusItem.init(entity:))
        self.items = items
        broadcast()
        
        if let focusItemId = UserDefaults.standard.string(forKey: UserDefaultKey.focusItemID.rawValue) {
            focusItem = items.first(where: { $0.id == focusItemId }) ?? items.first
        }
    }
}

