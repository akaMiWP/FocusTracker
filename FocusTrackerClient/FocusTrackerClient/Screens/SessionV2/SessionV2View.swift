//
//  Created by akaMiWP on 1/12/2568 BE.
//  Copyright © 2568 BE. All rights reserved.

import SwiftUI

struct SessionV2View: View {
    
    @StateObject var viewModel: SessionV2ViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            if let item = viewModel.focusedItem {
                TimerView(countdownText: "25:00")
                
                HStack {
                    Button(action: {}) {
                        Text("Stop")
                    }
                    .buttonStyle(.glass)
                    
                    Button(action: {}) {
                        Text("Start")
                    }
                    .buttonStyle(.glassProminent)
                }
                
                VStack(alignment: .leading) {
                    Text("Session detail")
                        .font(.headline)
                    Text(item.title)
                        .font(.subheadline)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                .shadow(color: Color.black.opacity(0.2), radius: 8)
                .padding(.horizontal, 12)
            } else {
                Text("Please select a focus item")
            }
        }
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
