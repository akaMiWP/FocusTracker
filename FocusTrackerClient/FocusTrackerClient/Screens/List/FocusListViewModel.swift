import Combine

final class FocusListViewModel: ObservableObject {
    @Published var items: [FocusItem] = [
        .init(title: "A", duration: 0),
        .init(title: "B", duration: 0),
        .init(title: "C", duration: 0),
        .init(title: "D", duration: 0)
    ]
}
