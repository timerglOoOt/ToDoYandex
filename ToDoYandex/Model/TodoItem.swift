import Foundation

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
    var isDone: Bool
    var createdDate: Date
    let modifiedDate: Date?
    var hexColor: String?

    // MARK: Добавил конструктор, чтобы можно было избежать опциональные поля при инициализации

    init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date? = nil, isDone: Bool = false, createdDate: Date = Date(), modifiedDate: Date? = nil, hexColor: String? = nil) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.hexColor = hexColor
    }
}

extension TodoItem {
    var isHighPriority: Bool {
        priority == .high
    }
}
