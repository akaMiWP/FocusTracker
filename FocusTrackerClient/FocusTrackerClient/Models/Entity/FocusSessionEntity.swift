//
//  Created by akaMiWP on 4/12/2568 BE.
//  Copyright © 2568 BE. All rights reserved.
    
import Foundation
import SwiftData

@Model
final class FocusSessionEntity {
    @Attribute(.unique) var id: String

    var focusItem: FocusItemEntity
    var startTime: Date
    var endTime: Date?
    
    init(id: String, focusItem: FocusItemEntity, startTime: Date, endTime: Date? = nil) {
        self.id = id
        self.focusItem = focusItem
        self.startTime = startTime
        self.endTime = endTime
    }
}

extension FocusSessionEntity {
    convenience init(session: FocusSession, focusItem: FocusItemEntity) {
        self.init(
            id: session.id,
            focusItem: focusItem,
            startTime: session.startTime,
            endTime: session.endTime
        )
    }
}
