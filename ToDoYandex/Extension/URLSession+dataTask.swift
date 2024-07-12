import Foundation
import CocoaLumberjackSwift

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var task: URLSessionDataTask?

        return try await withTaskCancellationHandler {
            DDLogInfo("Starting data task for URL: \(urlRequest.url?.absoluteString ?? "unknown URL")")
            return try await withCheckedThrowingContinuation { continuation in
                task = self.dataTask(with: urlRequest) { data, response, error in
                    if Task.isCancelled {
                        DDLogWarn("Task was cancelled before completion")
                        continuation.resume(throwing: CancellationError())
                        return
                    }
                    if let error {
                        DDLogError("Data task failed with error: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                        return
                    } else if let data, let response {
                        DDLogInfo("Data task succeeded with response: \(response)")
                        continuation.resume(returning: (data, response))
                        return
                    }
                    DDLogError("Data task failed with bad server response")
                    continuation.resume(throwing: URLError(.badServerResponse))
                }
                if Task.isCancelled {
                    DDLogWarn("Task was cancelled before starting")
                    continuation.resume(throwing: CancellationError())
                    return
                }
                task?.resume()
                DDLogInfo("Data task resumed")
            }
        } onCancel: { [weak task] in
            task?.cancel()
        }
    }
}
