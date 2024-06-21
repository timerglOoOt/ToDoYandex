import Foundation

final class FileCache {
    private (set) var items: [String: TodoItem] = [:]
    private var fileTable: [String: String] = [:]

    @discardableResult
    func addTask(_ task: TodoItem) -> Bool {
        let id = task.id
        if !checkKeyContaining(id: id) {
            items[id] = task
            return true
        }
        return false
    }

    @discardableResult
    func deleteTask(byId id: String) -> Bool {
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
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                let data = try Data(contentsOf: filePath)
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
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
}

private extension FileCache {
    func checkKeyContaining(id: String) -> Bool {
        return items[id] != nil
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func getFilePath(for filename: String) throws -> URL {
        if let filePathString = fileTable[filename],
           let filePath = URL(string: filePathString) {
            return filePath
        }

        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        fileTable[filename] = filePath.absoluteString
        return filePath
    }
}
