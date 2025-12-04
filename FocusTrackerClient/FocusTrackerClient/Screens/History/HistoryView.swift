//
//  Created by akaMiWP on 4/12/2568 BE.
//  Copyright © 2568 BE. All rights reserved.
    
import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel: HistoryViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.focusSessions) { session in
                VStack(alignment: .leading, spacing: 12) {
                    Text(session[keyPath: \.focusItem.title])
                    Text(String(session[keyPath: \.focusItem.duration]))
                    
                    if let tag = session[keyPath: \.focusItem.tag]  {
                        Text(tag)
                    }
                }
            }
        }
    }
}
