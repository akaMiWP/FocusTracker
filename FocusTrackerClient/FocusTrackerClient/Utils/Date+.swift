//
//  Created by akaMiWP on 4/12/2568 BE.
//  Copyright © 2568 BE. All rights reserved.
    
import Foundation

extension Date {
    /// Returns the date at the start of the day (12:00 AM), which serves as a unique key for grouping.
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
