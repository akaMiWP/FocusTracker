import Foundation

struct FocusSession: Identifiable {
    let id: String
    let focusItem: FocusItem
    let startTime: Date
    var endTime: Date?
    
    var duration: TimeInterval {
        guard let endTime = endTime else { return 0 }
        return endTime.timeIntervalSince(startTime)
    }
    
    var isActive: Bool { endTime == nil }
    
    init(id: String = UUID().uuidString, focusItem: FocusItem, startTime: Date, endTime: Date? = nil) {
        self.id = id
        self.focusItem = focusItem
        self.startTime = startTime
        self.endTime = endTime
    }
}

extension FocusSession {
    init(entity: FocusSessionEntity) {
        self.init(
            id: entity.id,
            focusItem: .init(entity: entity.focusItem),
            startTime: entity.startTime,
            endTime: entity.endTime
        )
    }
}
