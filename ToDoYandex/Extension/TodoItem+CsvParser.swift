import Foundation

extension TodoItem {
    var csv: String {
        let components = [
            id,
            "'\(text)'",
            priority.rawValue,
            "\(isDone)",
            ISO8601DateFormatter().string(from: createdDate),
            deadline != nil ? ISO8601DateFormatter().string(from: deadline!) : "empty",
            modifiedDate != nil ? ISO8601DateFormatter().string(from: modifiedDate!) : "empty"
        ]
        return components.joined(separator: ",")
    }

    static func parseCsv(csv: String) -> TodoItem? {
        let components = parseCsvComponent(csv: csv)
        guard components.count == 7  else {
            print("Полученные данные не соответствуют модели")
            return nil
        }
        let id = components[0]
        let text = components[1]
        let priority = Priority(rawValue: components[2]) ?? .normal
        let isDoneString = components[3]
        let createdDateString = components[4]
        let deadlineDateString = components[5]
        let modifiedDateString = components[6]

        guard let isDone = Bool(isDoneString) else {
            print("Полученные данные не соответствуют типу свойства isDone")
            return nil
        }
        guard let createdDate = ISO8601DateFormatter().date(from: createdDateString) else {
            print("Полученные данные не соответствуют типу даты")
            return nil
        }

        let deadlineDate: Date?
        if deadlineDateString != "empty" {
            if let parsedDate = ISO8601DateFormatter().date(from: deadlineDateString) {
                deadlineDate = parsedDate
            } else {
                print("Полученные данные не соответствуют типу даты")
                return nil
            }
        } else {
            deadlineDate = nil
        }

        let modifiedDate: Date?
        if modifiedDateString != "empty" {
            if let parsedDate = ISO8601DateFormatter().date(from: modifiedDateString) {
                modifiedDate = parsedDate
            } else {
                print("Полученные данные не соответствуют типу даты")
                return nil
            }
        } else {
            modifiedDate = nil
        }

        return TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadlineDate,
            isDone: isDone,
            createdDate: createdDate,
            modifiedDate: modifiedDate
        )
    }

    static func toCsv(items: [TodoItem]) -> String {
        return items.map { $0.csv }.joined(separator: "\n")
    }

    private static func parseCsvComponent(csv: String) -> [String] {
        var components: [String] = []
        var currentComponent = ""
        var isTextComponent = false
        for char in csv {
            if char == "'" {
                isTextComponent.toggle()
                continue
            } else if !isTextComponent && char == "," {
                components.append(currentComponent)
                currentComponent = ""
                continue
            }
            currentComponent.append(char)
        }
        components.append(currentComponent)
        return components
    }
}
