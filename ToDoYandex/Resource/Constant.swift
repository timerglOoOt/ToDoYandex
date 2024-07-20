import Foundation

enum Constant {
    enum DateFormate: String {
        case dayWithFullMonth = "dd MMMM"
        case dayWithFullMonthAndYear = "dd MMMM yyyy"
    }
    enum Network {
        static let baseUrl = "https://beta.mrdekk.ru/todo"
        static let bearerToken = "Ваш токен"
    }
    enum Retry {
        static let minDelay = 2.0
        static let retries = 3
        static let maxDelay = 120.0
        static let factor = 1.5
        static let jitter = 0.05
    }
}
