import Foundation
import Combine
import FileCache

final class ContentViewModel: ObservableObject {
    @Published var items: [TodoItem]
    let fileCache: FileCache<TodoItem>
    private var cancellable = Set<AnyCancellable>()
    private let filename: String

    var doneItemsCount: Int {
        items.filter { $0.isDone }.count
    }

    init(fileCache: FileCache<TodoItem>, filename: String) {
        self.fileCache = fileCache
        self.items = Array(fileCache.items.values)
        self.filename = filename
        Task {
            try await fileCache.load(from: filename)
        }
        self.fileCache.$items.sink { items in
            self.updateItems(items)
        }.store(in: &cancellable)
    }

    func updateItemStatus(id: String) {
        guard let item = fileCache.getItem(by: id) else { return }
        let newItem = item.toggleIsDone()
        fileCache.updateItem(newItem)
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
