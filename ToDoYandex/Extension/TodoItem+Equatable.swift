import Foundation

extension TodoItem: Equatable {
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id
        && lhs.text == rhs.text
        && lhs.isDone == rhs.isDone
        && lhs.priority == rhs.priority
    }
}
