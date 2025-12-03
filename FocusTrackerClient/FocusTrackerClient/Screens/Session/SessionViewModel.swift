//
//  Created by akaMiWP on 1/12/2568 BE.
//  Copyright © 2568 BE. All rights reserved.
    
import Combine
import Foundation

@MainActor
final class SessionViewModel: ObservableObject {
    
    @Published var focusedItem: FocusItem?
    @Published var focusItems: [FocusItem] = []
    
    ///Timer properties
    @Published var remainingTime: TimeInterval?
    var isSessionActive: Bool { countdownTask != nil }
    private var countdownTask: Task<Void, Never>?
    
    private let itemsRepository: ItemsRepositoryProtocol
    private var focusedItemTask: Task<Void, Never>?
    private var focusItemsTask: Task<Void, Never>?

    init(itemsRepository: ItemsRepositoryProtocol) {
        self.itemsRepository = itemsRepository
        
        focusedItemTask = Task { [weak self] in
            guard let self else { return }
            for await item in await itemsRepository.focusedItemStream {
                self.focusedItem = item
                self.remainingTime = item?.timeInSeconds
            }
        }
        
        focusItemsTask = Task { [weak self] in
            guard let self else { return }
            for await items in await itemsRepository.focusItemsStream {
                self.focusItems = items
            }
        }
    }
    
    func select(_ item: FocusItem) {
        Task { [weak self] in
            guard let self else { return }
            await itemsRepository.save(key: .focusItemID, value: item.id)
        }
    }
}

// MARK: - Timer
extension SessionViewModel {
    func startTimer() {
        resetCountdownTask()
        remainingTime = focusedItem?.timeInSeconds
        countdownTask = Task { [weak self] in
            guard let self else { return }
            
            while let current = self.remainingTime, current > 0 {
                try? await Task.sleep(for: .seconds(1))
                remainingTime = current - 1
            }
            //TODO: show dialog timer alert done + record a session
        }
    }
    
    func resumeTimer() {
        countdownTask = Task { [weak self] in
            guard let self, let remainingTime else { return }
            
            while remainingTime > 0 {
                try? await Task.sleep(for: .seconds(1))
            }
            //TODO: show dialog timer alert done + record a session
        }
    }
    
    func stopTimer() {
        resetCountdownTask()
    }
    
    func cancelTimer() {
        resetCountdownTask()
        remainingTime = focusedItem?.timeInSeconds
    }
}

// MARK: - Private
private extension SessionViewModel {
    func resetCountdownTask() {
        countdownTask?.cancel()
        countdownTask = nil
    }
}

private extension FocusItem {
    var timeInSeconds: Double {
        Double(duration * 60)
    }
}
