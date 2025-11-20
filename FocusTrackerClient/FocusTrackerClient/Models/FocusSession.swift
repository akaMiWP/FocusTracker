import Foundation

struct FocusSession {
    let id: String
    let focusItemID: String
    let startTime: Date
    let endTime: Date?
    
    var duration: TimeInterval {
        guard let endTime = endTime else { return 0 }
        return endTime.timeIntervalSince(startTime)
    }
    
    var isActive: Bool { endTime == nil }
}
