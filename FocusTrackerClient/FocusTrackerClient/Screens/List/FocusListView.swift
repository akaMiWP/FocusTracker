import SwiftUI

struct FocusListView: View {
    
    @State private var input: String = ""
    @FocusState private var isKeyboardFocused: Bool
    
    @State private var items: [FocusItem] = [
        .init(title: "A", duration: 0),
        .init(title: "B", duration: 0),
        .init(title: "C", duration: 0),
        .init(title: "D", duration: 0)
    ]
    
    var body: some View {
        VStack {
            ForEach(items) { item in
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
                    items.append(newItem)
                    
                    input = ""
                }
            }
        }
    }
}

#Preview {
    FocusListView()
}

