//
//  Created by akaMiWP on 4/12/2568 BE.
//  Copyright © 2568 BE. All rights reserved.

import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel: HistoryViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.groupedSessions.keys.sorted(by: >), id: \.self) { dateKey in
                Section {
                    if let sessionsForDay = viewModel.groupedSessions[dateKey] {
                        ForEach(sessionsForDay) { session in
                            VStack(alignment: .leading, spacing: 12) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text(session[keyPath: \.focusItem.title])
                                        Spacer()
                                        
                                        if let endTime = session[keyPath: \.endTime] {
                                            let formattedTime = endTime.formatted(date: .omitted, time: .shortened)
                                            Text(formattedTime)
                                        }
                                    }
                                    .font(.body)
                                    
                                    HStack {
                                        Text("duration:")
                                        Spacer()
                                        Text(String(session[keyPath: \.focusItem.duration]))
                                    }
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                    
                                    if let tag = session[keyPath: \.focusItem.tag]  {
                                        Text(tag)
                                            .font(.footnote)
                                            .foregroundStyle(.gray)
                                    }
                                }
                            }
                        }
                    }
                } header: {
                    Text(dateKey, style: .date)
                        .font(.headline)
                }
            }
        }
    }
}
