import Foundation

enum Priority: String {
    case low = "Неважное"
    case normal = "Обычное"
    case high = "Важное"
}

struct TodoItem {
    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let isDone: Bool
    let createdDate: Date
    let modifiedDate: Date?

    // MARK: Добавил конструктор, чтобы можно было избежать опциональные поля при инициализации

    init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date? = nil, isDone: Bool = false, createdDate: Date = Date(), modifiedDate: Date? = nil) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}
