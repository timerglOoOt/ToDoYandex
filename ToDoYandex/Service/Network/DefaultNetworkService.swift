import CocoaLumberjack

final class DefaultNetworkingService: NetworkingService {
    private let session: URLSession
    private let token: String
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()

    init(token: String) {
        self.token = token
        self.session = URLSession(configuration: .default)
    }

    func getList() async throws -> TodoListResponse {
        DDLogInfo("Fetching todo list")
        let data = try await makeRequest(endpoint: "/list", method: "GET")
        let response = try mapTodoListResponse(from: data)
        DDLogInfo("Successfully fetched todo list")
        return response
    }

    func updateList(_ list: [TodoItem], revision: Int) async throws -> TodoListResponse {
        DDLogInfo("Updating todo list with \(list.count) items, revision: \(revision)")
        let body = try jsonEncoder.encode(list)
        let data = try await retry(operation: {
            try await self.makeRequest(endpoint: "/list", method: "PATCH", body: body, revision: revision)
        })
        let response = try mapTodoListResponse(from: data)
        DDLogInfo("Successfully updated todo list")
        return response
    }

    func getItem(id: String) async throws -> TodoItem {
        DDLogInfo("Fetching todo item with id: \(id)")
        let data = try await makeRequest(endpoint: "/list/\(id)", method: "GET")
        let response = try mapTodoItem(from: data)
        DDLogInfo("Successfully fetched todo item with id: \(id)")
        return response
    }

    func addItem(_ item: TodoItem, revision: Int) async throws -> TodoItem {
        DDLogInfo("Adding todo item with id: \(item.id), revision: \(revision)")
        let body = try jsonEncoder.encode(item)
        let data = try await retry(operation: {
            try await self.makeRequest(endpoint: "/list", method: "POST", body: body, revision: revision)
        })
        let response = try mapTodoItem(from: data)
        DDLogInfo("Successfully added todo item with id: \(item.id)")
        return response
    }

    func updateItem(_ item: TodoItem) async throws -> TodoItem {
        DDLogInfo("Updating todo item with id: \(item.id)")
        let body = try jsonEncoder.encode(item)
        let data = try await retry(operation: {
            try await self.makeRequest(endpoint: "/list/\(item.id)", method: "PUT", body: body)
        })
        let response = try mapTodoItem(from: data)
        DDLogInfo("Successfully updated todo item with id: \(item.id)")
        return response
    }

    @discardableResult
    func deleteItem(id: String) async throws -> TodoItem {
        DDLogInfo("Deleting todo item with id: \(id)")
        let data = try await retry(operation: {
            try await self.makeRequest(endpoint: "/list/\(id)", method: "DELETE")
        })
        let response = try mapTodoItem(from: data)
        DDLogInfo("Successfully deleted todo item with id: \(id)")
        return response
    }
}

private extension DefaultNetworkingService {
    func makeRequest(
        endpoint: String,
        method: String,
        body: Data? = nil,
        revision: Int? = nil) async throws -> Data {

        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            DDLogError("Invalid URL: \(baseURL)\(endpoint)")
            throw NetworkError.badRequest
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let revision = revision {
            request.addValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        }
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        DDLogInfo("Sending \(method) request to \(url)")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            DDLogError("Invalid response received for \(method) request to \(url)")
            throw NetworkError.unknownError
        }

        DDLogInfo("Received \(httpResponse.statusCode) response for \(method) request to \(url)")

        switch httpResponse.statusCode {
        case 200:
            return data
        case 400:
            DDLogError("Bad request for \(method) request to \(url)")
            throw NetworkError.badRequest
        case 401:
            DDLogError("Unauthorized request for \(method) request to \(url)")
            throw NetworkError.unauthorized
        case 404:
            DDLogError("Not found for \(method) request to \(url)")
            throw NetworkError.notFound
        case 500:
            DDLogError("Server error for \(method) request to \(url)")
            throw NetworkError.serverError
        default:
            DDLogError("Unexpected status code \(httpResponse.statusCode) for \(method) request to \(url)")
            throw NetworkError.unknownError
        }
    }

    func retry<T>(
        operation: @escaping () async throws -> T,
        retries: Int = Constant.Retry.retries,
        minDelay: TimeInterval = Constant.Retry.minDelay,
        maxDelay: TimeInterval = Constant.Retry.maxDelay,
        factor: Double = Constant.Retry.factor,
        jitter: Double = Constant.Retry.jitter) async throws -> T {

        var attempts = 0
        var delay = minDelay

        while attempts < retries {
            do {
                return try await operation()
            } catch {
                attempts += 1
                if attempts >= retries {
                    DDLogError("Retry limit reached for operation. Returning fallback data.")
                    return try await getList()
                }

                let jitterValue = delay * jitter * (Double.random(in: 0..<1) - 0.5)
                let delayWithJitter = delay + jitterValue
                DDLogInfo("Retry attempt \(attempts) failed. Retrying in \(delayWithJitter) seconds...")
                try await Task.sleep(nanoseconds: Int(delayWithJitter * Double(NSEC_PER_SEC)))
                delay = min(delay * factor, maxDelay)
            }
        }
        DDLogError("Final retry attempt failed")
        throw NetworkError.unknownError
    }

    func mapTodoItem(from data: Data) throws -> TodoItem {
        let response = try jsonDecoder.decode([String: Any].self, from: data)
        guard let todoItem = TodoItem.fromServerResponse(response) else {
            throw NetworkError.invalidData
        }
        return todoItem
    }

    func mapTodoListResponse(from data: Data) throws -> TodoListResponse {
        let response = try jsonDecoder.decode([String: Any].self, from: data)
        guard let todoListResponse = TodoListResponse.fromServerResponse(response) else {
            throw NetworkError.invalidData
        }
        return todoListResponse
    }
}
