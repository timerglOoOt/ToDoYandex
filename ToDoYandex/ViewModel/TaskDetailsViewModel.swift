import Foundation
import SwiftUI

final class TaskDetailsViewModel: ObservableObject {
    private let fileCache: FileCache
    @Published var taskText: String = ""
    @Published var priority: Priority = .normal
    @Published var deadlineEnabled: Bool = false
    @Published var deadline: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @Published var hexColor: String = ""
    @Published var category: TodoItemCategory = .none
    let id: String

    init(fileCache: FileCache, id: String) {
        self.fileCache = fileCache
        self.id = id == "" ? UUID().uuidString : id
        configureValues(with: id)
    }

    func updateTodoItem(_ item: TodoItem) {
        fileCache.updateItem(item)
    }

    func addTodoItem(_ item: TodoItem) {
        if fileCache.isItemExist(by: item.id) {
            fileCache.updateItem(item)
        } else {
            fileCache.addItem(item)
        }
    }

    func deleteTodoItem(by id: String) {
        fileCache.deleteItem(byId: id)
    }

    private func configureValues(with id: String) {
        guard let item = fileCache.getItem(by: id) else { return }
        taskText = item.text
        priority = item.priority
        category = item.category
        if let itemHexColor = item.hexColor {
            hexColor = itemHexColor
        }
        if let itemDeadline = item.deadline {
            deadline = itemDeadline
            deadlineEnabled = true
        } else {
            deadlineEnabled = false
        }
    }
}
