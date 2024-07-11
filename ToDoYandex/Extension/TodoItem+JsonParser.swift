import Foundation
//import FileCachePackage

extension TodoItem {
    var json: Any {
        var itemInfo: [String: Any] = [
            "id": id,
            "text": text,
            "isDone": isDone,
            "createdDate": ISO8601DateFormatter().string(from: createdDate),
            "category": category.id
        ]

        if priority != .normal {
            itemInfo["priority"] = priority.rawValue
        }

        if let deadline {
            itemInfo["deadline"] = ISO8601DateFormatter().string(from: deadline)
        }

        if let modifiedDate {
            itemInfo["deadline"] = ISO8601DateFormatter().string(from: modifiedDate)
        }

        // MARK: решил использовать такую конструкцию для обработки ошибок создания json,
        // в случае неудачи вернем пустую map

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: itemInfo)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData)
            if let jsonDict = jsonObject as? [String: Any] {
                return jsonDict
            }
        } catch {
            print("JSON serialization error: \(error.localizedDescription)")
        }
        return [:]
    }

    // MARK: здесь вообще без обработки ошибок, потому что возвращаем опционал

    static func parseJson(json: Any) -> TodoItem? {
        guard let jsonObject = json as? [String: Any] else { return nil }

        guard let id = jsonObject["id"] as? String,
              let text = jsonObject["text"] as? String,
              let isDone = jsonObject["isDone"] as? Bool,
              let categoryString = jsonObject["category"] as? String,
              let createdDateString = jsonObject["createdDate"] as? String,
              let createdDate = ISO8601DateFormatter().date(from: createdDateString) else { return nil }

        let priorityString = jsonObject["priority"] as? String ?? "Обычное"
        guard let priority = Priority(rawValue: priorityString) else { return nil }

        let category = TodoItemCategory.getCategoryByName(categoryString) ?? .none

        var deadline: Date?
        if let deadlineString = jsonObject["deadline"] as? String {
            deadline = ISO8601DateFormatter().date(from: deadlineString)
        }

        var modifiedDate: Date?
        if let modifiedDateString = jsonObject["modifiedDate"] as? String {
            modifiedDate = ISO8601DateFormatter().date(from: modifiedDateString)
        }

        return TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: isDone,
            createdDate: createdDate,
            modifiedDate: modifiedDate,
            category: category
        )
    }
}
