import SwiftUI
import UIKit
//import FileCachePackage

enum Priority: String {
    case low = "Неважное"
    case normal = "Обычное"
    case high = "Важное"
}

struct TodoItem: Identifiable {
    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let isDone: Bool
    let createdDate: Date
    let modifiedDate: Date?
    let hexColor: String?
    let category: TodoItemCategory
    let files: [String]?

    // MARK: Добавил конструктор, чтобы можно было избежать опциональные поля при инициализации

    init(
        id: String = UUID().uuidString,
        text: String,
        priority: Priority,
        deadline: Date? = nil,
        isDone: Bool = false,
        createdDate: Date = Date(),
        modifiedDate: Date? = nil,
        hexColor: String? = nil,
        category: TodoItemCategory = .none,
        files: [String]? = nil
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.hexColor = hexColor
        self.category = category
        self.files = files
    }
}

extension TodoItem {
    var isHighPriority: Bool {
        priority == .high
    }

    func toggleIsDone() -> Self {
        return TodoItem(
            id: self.id,
            text: self.text,
            priority: self.priority,
            deadline: self.deadline,
            isDone: !self.isDone,
            createdDate: self.createdDate,
            modifiedDate: self.modifiedDate,
            hexColor: self.hexColor,
            category: self.category,
            files: self.files
        )
    }
}
