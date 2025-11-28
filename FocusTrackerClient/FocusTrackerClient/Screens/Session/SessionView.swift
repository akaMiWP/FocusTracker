//Timer Screen
//   Start → Running
//   Pause → Paused
//   Resume → Running
//   Stop → Complete session
//   Back → List

import SwiftUI

struct SessionView: View {
    
    @StateObject var viewModel: SessionViewModel
    
    var body: some View {
        VStack {
            
            VStack {
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
            
            Spacer()
            
            Text("20:00")
            
            HStack {
                Button(action: {}) {
                    Text("Stop")
                }
                
                Button(action: {}) {
                    Text("Start")
                }
            }
        }
    }
}
