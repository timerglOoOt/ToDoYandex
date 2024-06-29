import Foundation

extension Date {
    func toString(with dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }
}
