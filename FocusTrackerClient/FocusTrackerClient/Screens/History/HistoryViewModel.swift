//
//  Created by akaMiWP on 4/12/2568 BE.
//  Copyright © 2568 BE. All rights reserved.
    
import Combine
import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {
    
    @Published var focusSessions: [FocusSession] = []
    private let itemsRepository: ItemsRepositoryProtocol
    private var focusSessionsTask: Task<Void, Never>?
    
    init(itemsRepository: ItemsRepositoryProtocol) {
        self.itemsRepository = itemsRepository
        self.focusSessionsTask = Task { [weak self] in
            guard let self else { return }
            for await sessions in await itemsRepository.focusSessionsStream {
                self.focusSessions = sessions
            }
        }
    }
}

extension HistoryViewModel {
    var groupedSessions: [Date: [FocusSession]] {
        Dictionary(grouping: focusSessions) { $0.startTime.startOfDay }
    }
}
