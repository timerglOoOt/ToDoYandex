import Foundation

extension TodoItem {
    private static func dateFromUnixTimestamp(_ timestamp: Int64?) -> Date? {
        guard let timestamp = timestamp else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }

    private static func priorityFromString(_ priorityString: String?) -> Priority {
        switch priorityString {
        case "low": return .low
        case "basic": return .normal
        case "important": return .high
        default: return .normal
        }
    }

    static func fromServerResponse(_ response: [String: Any]) -> TodoItem? {
        guard let id = response["id"] as? String,
            let text = response["text"] as? String,
            let importance = response["importance"] as? String,
            let done = response["done"] as? Bool,
            let createdAt = response["created_at"] as? Int64,
            let lastUpdatedBy = response["last_updated_by"] as? String
        else {
            return nil
        }

        let deadline = dateFromUnixTimestamp(response["deadline"] as? Int64)
        let createdDate = dateFromUnixTimestamp(createdAt) ?? Date.now
        let modifiedDate = dateFromUnixTimestamp(response["changed_at"] as? Int64)
        let hexColor = response["color"] as? String
        let priority = priorityFromString(importance)
        let files = response["files"] as? [String]

        return TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: done,
            createdDate: createdDate,
            modifiedDate: modifiedDate,
            hexColor: hexColor,
            files: files,
            lastUpdatedBy: lastUpdatedBy
        )
    }
}
