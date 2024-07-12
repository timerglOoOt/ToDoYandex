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

    @MainActor private static var _allCases: [TodoItemCategory] = [.work, .study, .hobby, .none]

    @MainActor static var allCases: [TodoItemCategory] {
        return _allCases
    }

    @MainActor static func addCustomCategory(name: String, color: UIColor) {
        if !_allCases.contains(.custom(name: name, color: color)) {
            _allCases.append(.custom(name: name, color: color))
        }
    }

    @MainActor static func getCategoryByName(_ name: String) -> TodoItemCategory? {
        return _allCases.first { $0.id == name }
    }
}
