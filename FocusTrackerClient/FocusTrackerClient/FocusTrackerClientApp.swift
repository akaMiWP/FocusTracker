import SwiftData
import SwiftUI

@main
struct FocusTrackerClientApp: App {
    var body: some Scene {
        WindowGroup {
            RootWrapper()
                .modelContainer(for: [FocusItemEntity.self, FocusSessionEntity.self])
        }
    }
}
