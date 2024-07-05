import Foundation
import UIKit

enum Priority: String {
    case low = "Неважное"
    case normal = "Обычное"
    case high = "Важное"
}

enum TodoItemCategory: String, CaseIterable, Identifiable {
    case work = "Работа"
    case study = "Учеба"
    case hobby = "Хобби"
    case none = "Другое"

    var id: Self { self }
    
    var color: UIColor {
        switch self {
        case .none: return .clear
        case .work: return .systemRed
        case .study: return .systemBlue
        case .hobby: return .systemGreen
        }
    }
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
    var category: TodoItemCategory

    // MARK: Добавил конструктор, чтобы можно было избежать опциональные поля при инициализации

    init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date? = nil, isDone: Bool = false, createdDate: Date = Date(), modifiedDate: Date? = nil, hexColor: String? = nil, category: TodoItemCategory = .none) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.hexColor = hexColor
        self.category = category
    }
}

extension TodoItem {
    var isHighPriority: Bool {
        priority == .high
    }
}
