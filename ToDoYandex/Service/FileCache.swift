import Foundation

final class FileCache: ObservableObject {
    @Published private (set) var items: [String: TodoItem] = [:]
    private var fileTable: [String: String] = [:]

    @discardableResult
    func addItem(_ task: TodoItem) -> Bool {
        let id = task.id
        if !checkKeyContaining(id: id) {
            items[id] = task
            return true
        }
        return false
    }

    @discardableResult
    func deleteItem(byId id: String) -> Bool {
        if checkKeyContaining(id: id) {
            items.removeValue(forKey: id)
            return true
        }
        return false
    }

    func save(to filename: String) async throws {
        let itemsArray = items.values.map { $0.json }
        do {
            let data = try JSONSerialization.data(withJSONObject: itemsArray, options: .prettyPrinted)
            let filePath = try getFilePath(for: filename)
            try data.write(to: filePath, options: .atomic)
        } catch {
            throw error
        }
    }

    func load(from filename: String) async throws {
        let filePath = try getFilePath(for: filename)
        if FileManager.default.fileExists(atPath: filePath.path()) {
            do {
                let data = try Data(contentsOf: filePath)
                if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                    var loadedItems: [String: TodoItem] = [:]
                    for dict in jsonArray {
                        if let item = TodoItem.parseJson(json: dict) {
                            loadedItems[item.id] = item
                        }
                    }

                    items = loadedItems
                }
            } catch {
                throw error
            }
        } else {
            let error = NSError(domain: "FileCache", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found: \(filename)"])
            throw error
        }
    }

    func getItem(by id: String) -> TodoItem? {
        return items[id]
    }

    func isItemExist(by id: String) -> Bool {
        return getItem(by: id) != nil
    }

    func updateItem(_ item: TodoItem) {
        let id = item.id
        items[id] = item
    }

    func updateItemStatus(id: String) {
        if isItemExist(by: id) {
            items[id] = updateStatus(items[id])
        }
    }
}

private extension FileCache {
    func checkKeyContaining(id: String) -> Bool {
        return items[id] != nil
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func getFilePath(for filename: String) throws -> URL {
        if let filePathString = fileTable[filename],
           let filePath = URL(string: filePathString) {
            return filePath
        }

        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        fileTable[filename] = filePath.absoluteString
        return filePath
    }

    func updateStatus(_ item: TodoItem?) -> TodoItem? {
        guard let item else { return nil }
        return TodoItem(
            id: item.id,
            text: item.text,
            priority: item.priority,
            deadline: item.deadline,
            isDone: !item.isDone,
            createdDate: item.createdDate,
            modifiedDate: item.modifiedDate,
            hexColor: item.hexColor,
            category: item.category
        )
    }
}
