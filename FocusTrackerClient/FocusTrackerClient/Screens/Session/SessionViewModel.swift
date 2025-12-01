import Combine
import Foundation

private let baseDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? .init()

final class SessionViewModel: ObservableObject {
    @Published var focusedItem: FocusItem?
    private let itemsRepository: ItemsRepositoryProtocol
    private var focusedItemTask: Task<Void, Never>?
    private var countdownTask: Task<Void, Never>?
    
    ///Timer properties
    @Published var selectedTime: Date
    @Published var remainingTime: TimeInterval?
    private var totalTimeCountdown: TimeInterval {
        selectedTime.timeIntervalSince1970 - baseDate.timeIntervalSince1970
    }
    
    var isTimerActive: Bool { countdownTask != nil }
    
    init(itemsRepository: ItemsRepositoryProtocol) {
        self.itemsRepository = itemsRepository
        self.selectedTime  = Calendar.current.date(bySettingHour: 0, minute: 25, second: 0, of: Date()) ?? .init()
        
        focusedItemTask = Task { [weak self] in
            guard let self else { return }
            for await focusedItem in await itemsRepository.focusedItemStream {
                self.focusedItem = focusedItem
            }
        }
    }
    
    func startTimer() {
        remainingTime = totalTimeCountdown
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
        countdownTask = nil
    }
    
    func cancelTimer() {
        remainingTime = totalTimeCountdown
        countdownTask = nil
    }
}
