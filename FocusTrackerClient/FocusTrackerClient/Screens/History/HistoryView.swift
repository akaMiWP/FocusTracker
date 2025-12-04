//
//  Created by akaMiWP on 4/12/2568 BE.
//  Copyright © 2568 BE. All rights reserved.
    
import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel: HistoryViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.focusSessions) { session in
                Text(session.focusItemID)
            }
        }
    }
}
