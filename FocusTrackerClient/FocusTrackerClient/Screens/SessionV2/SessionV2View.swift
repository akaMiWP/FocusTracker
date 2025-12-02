//
//  Created by akaMiWP on 1/12/2568 BE.
//  Copyright © 2568 BE. All rights reserved.

import SwiftUI

struct SessionV2View: View {
    
    @StateObject var viewModel: SessionV2ViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            if let item = viewModel.focusedItem {
                HStack {
                    Text("Select an item to focus:")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Picker("Select an item", selection: $viewModel.focusedItem) {
                        Text("None").tag(nil as String?)

                        ForEach(viewModel.focusItems, id: \.id) { item in
                            Text(item.title).tag(item)
                        }
                    }
                    .disabled(viewModel.isSessionActive)
                    .onChange(of: item) { _, newValue in
                        viewModel.select(newValue)
                    }
                }
                
                TimerView(countdownText: formatted(timeInterval: viewModel.remainingTime))
                
                HStack {
                    Button(action: viewModel.stopTimer) {
                        Text("Stop")
                    }
                    .buttonStyle(.glass)
                    
                    Button(action: viewModel.startTimer) {
                        Text("Start")
                    }
                    .buttonStyle(.glassProminent)
                }
                
                VStack(alignment: .leading) {
                    Text("Session detail")
                        .font(.headline)
                    
                    RowView(leadingText: "Title:", trailingText: item.title)
                    
                    RowView(leadingText: "Tag:", trailingText: item.tag ?? "")
                    
                    RowView(leadingText: "Duration:", trailingText: String(item.duration))
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                .shadow(color: Color.black.opacity(0.2), radius: 8)
                
                Spacer()
            } else {
                Text("Please select a focus item")
            }
        }
        .padding(.horizontal, 16)
    }
}

struct TimerView: View {
    
    private let countdownText: String
    
    init(countdownText: String) {
        self.countdownText = countdownText
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.blue, lineWidth: 8)
                .frame(width: 150, height: 150)
            
            Text(countdownText)
                .font(.headline)
                .foregroundStyle(.primary)
        }
    }
}

struct RowView: View {
    let leadingText: String
    let trailingText: String
    
    var body: some View {
        HStack {
            Text(leadingText).font(.headline)
            
            Spacer()
            
            Text(trailingText).font(.subheadline)
        }
    }
}

// MARK: - Private
private extension SessionV2View {
    func formatted(timeInterval: TimeInterval?) -> String {
        guard let timeInterval else { return "" }
        return Duration.seconds(timeInterval).formatted()
    }
}
