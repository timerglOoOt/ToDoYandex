import Foundation

protocol NetworkingService {
    func getList() async throws -> TodoListResponse
    func updateList(_ list: [TodoItem], revision: Int) async throws -> TodoListResponse
    func getItem(id: String) async throws -> TodoItemResponse
    func addItem(_ item: TodoItem, revision: Int) async throws -> TodoItemResponse
    func updateItem(_ item: TodoItem) async throws -> TodoItemResponse
    func deleteItem(id: String) async throws -> TodoItemResponse
}
