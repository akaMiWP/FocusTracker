import Foundation

struct FocusItem: Hashable, Identifiable {
    let id: String
    let title: String
    let tag: String?
    let duration: Int
    let createdAt: Date
    
    init(id: String = UUID().uuidString, title: String, tag: String? = nil, duration: Int, createdAt: Date = .init()) {
        self.id = id
        self.title = title
        self.tag = tag
        self.duration = duration
        self.createdAt = createdAt
    }
}

extension FocusItem {
    func with(
        id: String? = nil,
        title: String? = nil,
        tag: String? = nil,
        duration: Int?  = nil,
        createdAt: Date? = nil
    ) -> FocusItem {
        .init(
            id: id ?? self.id,
            title: title ?? self.title,
            tag: tag ?? self.tag,
            duration: duration ?? self.duration,
            createdAt: createdAt ?? self.createdAt
        )
    }
    
    init(entity: FocusItemEntity) {
        self.init(
            id: entity.id,
            title: entity.title,
            tag: entity.tag,
            duration: entity.duration,
            createdAt: entity.createdAt
        )
    }
}
