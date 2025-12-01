import SwiftUI

struct SessionView: View {
    
    @StateObject var viewModel: SessionViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Ohayo ! Select an item that you would like to focus")
                Button(action: {}) {
                    if let item = viewModel.focusedItem {
                        Text(item.title)
                    } else {
                        Text("No selected item")
                            .foregroundStyle(.gray)
                    }
                }
            }
            
            DatePicker("Duration", selection: $viewModel.selectedTime, displayedComponents: .hourAndMinute)
            
            HStack {
                Button(action: viewModel.stopTimer) {
                    Text("Stop")
                }
                
                Button(action: viewModel.startTimer) {
                    Text("Start")
                }
            }
            
            VStack {
                Text("Count down: \(formatted(timeInterval: viewModel.remainingTime))")
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Private
private extension SessionView {
    func formatted(timeInterval: TimeInterval?) -> String {
        guard let timeInterval else { return "" }
        return Duration.seconds(timeInterval).formatted()
    }
}
