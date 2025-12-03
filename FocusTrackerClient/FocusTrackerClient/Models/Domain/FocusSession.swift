import Foundation

struct FocusSession {
    let id: String
    let focusItemID: String
    let startTime: Date
    var endTime: Date?
    
    var duration: TimeInterval {
        guard let endTime = endTime else { return 0 }
        return endTime.timeIntervalSince(startTime)
    }
    
    var isActive: Bool { endTime == nil }
    
    init(id: String = UUID().uuidString, focusItemID: String, startTime: Date, endTime: Date? = nil) {
        self.id = id
        self.focusItemID = focusItemID
        self.startTime = startTime
        self.endTime = endTime
    }
}

import SwiftData
@Model
final class FocusSessionEntity {
    @Attribute(.unique) var id: String

    @Relationship(inverse: \FocusItemEntity.id)
    var focusItemID: String
    
    var startTime: Date
    var endTime: Date?
    
    init(id: String, focusItemID: String, startTime: Date, endTime: Date? = nil) {
        self.id = id
        self.focusItemID = focusItemID
        self.startTime = startTime
        self.endTime = endTime
    }
}

extension FocusSessionEntity {
    convenience init(session: FocusSession) {
        self.init(
            id: session.id,
            focusItemID: session.focusItemID,
            startTime: session.startTime,
            endTime: session.endTime
        )
    }
}
