import XCTest
@testable import ToDoYandex

final class URLSessionTest: XCTestCase {
    func test_success_request() async throws {
        guard let url = URL(string: "https://carapi.app/api/models?limit=1&year=2016") else { return }
        let urlRequest = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.dataTask(for: urlRequest)
            XCTAssertNotNil(data)
            XCTAssertNotNil(response)
            XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_error_request() async throws {
        let url = URL(string: "https://carap.app/api/models?lim=1&year=2016&stoimost=100")!
        let urlRequest = URLRequest(url: url)
        do {
            _ = try await URLSession.shared.dataTask(for: urlRequest)
            XCTFail("Recieved error")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func test_cancelled_request() async throws {
        let cancelExpectation = expectation(description: "The request is expected to be cancelled")
        guard let url = URL(string: "https://carapi.app/api/models?limit=1&year=2016") else { return }
        let urlRequest = URLRequest(url: url)

        let task = Task {
            do {
                _ = try await URLSession.shared.dataTask(for: urlRequest)
                XCTFail("The request should have been canceled")
            } catch is CancellationError {
                cancelExpectation.fulfill()
            }
        }
        task.cancel()
        await waitForExpectations(timeout: 1)
    }
}
