//
//  Created by akaMiWP on 4/12/2568 BE.
//  Copyright © 2568 BE. All rights reserved.
    
import Foundation
import SwiftData

@Model
final class FocusItemEntity {
    @Attribute(.unique) var id: String
    var title: String
    var tag: String?
    var duration: Int
    var createdAt: Date
    
    // Inverse relationship to sessions
    @Relationship(deleteRule: .cascade, inverse: \FocusSessionEntity.focusItem)
    var sessions: [FocusSessionEntity] = []
    
    init(id: String, title: String, tag: String? = nil, duration: Int, createdAt: Date = .now) {
        self.id = id
        self.title = title
        self.tag = tag
        self.duration = duration
        self.createdAt = createdAt
    }
}

extension FocusItemEntity {
    convenience init(item: FocusItem) {
        self.init(
            id: item.id,
            title: item.title,
            tag: item.tag,
            duration: item.duration,
            createdAt: item.createdAt
        )
    }
}
