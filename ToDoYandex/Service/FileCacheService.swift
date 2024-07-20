 import Foundation
 import CocoaLumberjackSwift

 final class FileCacheService {
     @Published private (set) var items: [String: TodoItem] = [:]
     private var fileTable: [String: String] = [:]
     let networkingService: NetworkingService

     init(networkingService: NetworkingService) {
         self.networkingService = networkingService
     }

    @discardableResult
    func addItem(_ task: TodoItem) -> Bool {
        let id = task.id
        if !checkKeyContaining(id: id) {
            items[id] = task
            Task {
                Revision.shared.incrementRevision()
//                try await networkingService.addItem(task, revision: Revision.shared.getRevision())
            }

            DDLogInfo("Added item with id: \(id)")
            return true
        }
        DDLogWarn("Attempted to add duplicate item with id: \(id)")
        return false
    }

    @discardableResult
    func deleteItem(byId id: String) -> Bool {
        if checkKeyContaining(id: id) {
            items.removeValue(forKey: id)
            DDLogInfo("Deleted item with id: \(id)")
            return true
        }
        DDLogWarn("Attempted to delete non-existent item with id: \(id)")
        return false
    }

    func save(to filename: String) async throws {
        let itemsArray = items.values.map { $0.json }
        do {
            let data = try JSONSerialization.data(withJSONObject: itemsArray, options: .prettyPrinted)
            let filePath = try getFilePath(for: filename)
            try data.write(to: filePath, options: .atomic)
            DDLogInfo("Saved items to file: \(filename)")
        } catch {
            DDLogError("Failed to save items to file: \(filename), error: \(error.localizedDescription)")
            throw error
        }
    }

     public func load(from filename: String) async throws {
         let filePath = try getFilePath(for: filename)
         if FileManager.default.fileExists(atPath: filePath.path()) {
             do {
                 let data = try Data(contentsOf: filePath)
                 if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                     var loadedItems: [String: TodoItem] = [:]
                     for dict in jsonArray {
                         if let item = await TodoItem.parseJson(json: dict) {
                             loadedItems[item.id] = item
                         }
                     }

                     items = loadedItems
                     DDLogInfo("Loaded items from file: \(filename)")
                 }
             } catch {
                 DDLogError("Failed to load items from file: \(filename), error: \(error.localizedDescription)")
                 throw error
             }
         } else {
             let error = NSError(
                 domain: "FileCache",
                 code: 404,
                 userInfo: [NSLocalizedDescriptionKey: "File not found: \(filename)"]
             )
             DDLogError("File not found: \(filename)")
             throw error
         }
     }

    func getItem(by id: String) -> TodoItem? {
        let item = items[id]
        if item != nil {
            DDLogInfo("Retrieved item with id: \(id)")
        } else {
            DDLogWarn("Item with id: \(id) not found")
        }
        return item
    }

    func isItemExist(by id: String) -> Bool {
        let exists = getItem(by: id) != nil
        DDLogInfo("Item existence check for id: \(id) - exists: \(exists)")
        return exists
    }

    func updateItem(_ item: TodoItem) {
        let id = item.id
        items[id] = item
        DDLogInfo("Updated item with id: \(id)")
    }
 }

 private extension FileCacheService {
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
 }
