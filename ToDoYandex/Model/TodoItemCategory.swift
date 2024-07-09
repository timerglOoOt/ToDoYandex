import UIKit

enum TodoItemCategory: Hashable, Identifiable {
    case work
    case study
    case hobby
    case none
    case custom(name: String, color: UIColor)

    var id: String {
        switch self {
        case .work: return "work"
        case .study: return "study"
        case .hobby: return "hobby"
        case .none: return "none"
        case .custom(let name, _): return name
        }
    }

    var name: String {
        switch self {
        case .work: return "Работа"
        case .study: return "Учеба"
        case .hobby: return "Хобби"
        case .none: return "Другое"
        case .custom(let name, _): return name
        }
    }

    var color: UIColor {
        switch self {
        case .none: return .clear
        case .work: return .systemRed
        case .study: return .systemBlue
        case .hobby: return .systemGreen
        case .custom(_, let color): return color
        }
    }

    static var allCases: [TodoItemCategory] = [.work, .study, .hobby, .none]

    static func addCustomCategory(name: String, color: UIColor) {
        if !allCases.contains(.custom(name: name, color: color)) {
            allCases.append(.custom(name: name, color: color))
        }
    }

    static func getCategoryByName(_ name: String) -> TodoItemCategory? {
        for category in allCases where category.id == name {
            return category
        }
        return nil
    }
}
