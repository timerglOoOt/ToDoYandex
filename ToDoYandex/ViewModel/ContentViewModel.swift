import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    @Published var items: [TodoItem]
    let fileCache: FileCache
    private var cancellable = Set<AnyCancellable>()
    private let filename: String

    var doneItemsCount: Int {
        items.filter { $0.isDone }.count
    }
    
    init(fileCache: FileCache, filename: String) {
        self.fileCache = fileCache
        self.items = Array(fileCache.items.values)
        self.filename = filename
        Task {
            try await fileCache.load(from: filename)
        }
        fileCache.$items.sink { items in
            self.updateItems(items)
        }.store(in: &cancellable)
    }

    func updateItemStatus(id: String) {
        fileCache.updateItemStatus(id: id)
    }

    func addTodoItem(_ item: TodoItem) {
        fileCache.addItem(item)
    }

    func deleteTodoItem(by id: String) {
        fileCache.deleteItem(byId: id)
    }

    func saveItems() {
        Task {
            try await fileCache.save(to: filename)
        }
    }
}

private extension ContentViewModel {
    func updateItems(_ items: [String: TodoItem]) {
        self.items = Array(items.values)
    }
}
