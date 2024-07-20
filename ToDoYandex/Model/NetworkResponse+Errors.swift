enum NetworkError: Error {
    case badRequest
    case unauthorized
    case notFound
    case serverError
    case unknownError
    case unsynchronizedData
}

struct TodoListResponse: Codable {
    let status: String
    let list: [TodoItem]
    let revision: Int
}

struct TodoItemResponse: Codable {
    let status: String
    let element: TodoItem
    let revision: Int
}
