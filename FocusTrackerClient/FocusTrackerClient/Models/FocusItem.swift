import Foundation

struct FocusItem {
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
