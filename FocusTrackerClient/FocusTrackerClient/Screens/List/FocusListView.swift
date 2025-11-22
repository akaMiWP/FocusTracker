import SwiftUI

struct FocusListView: View {
    @StateObject private var viewModel: FocusListViewModel = .init()
    @State private var input: String = ""
    @FocusState private var isKeyboardFocused: Bool
    
    var body: some View {
        VStack {
            ForEach(viewModel.items) { item in
                Text(item.title)
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Add To-Do item", text: $input)
                    .focused($isKeyboardFocused)
            }
            .padding(16)
            .background(Color.gray.opacity(0.4))
            .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isKeyboardFocused = false
                    
                    let newItem: FocusItem = .init(title: input, duration: 0)
                    viewModel.items.append(newItem)
                    
                    input = ""
                }
            }
        }
    }
}

#Preview {
    FocusListView()
}

