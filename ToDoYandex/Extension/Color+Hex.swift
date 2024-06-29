import SwiftUI

extension Color {
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else {
            return "#000000"
        }

        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        let hex = String(format: "#%02X%02X%02X", r, g, b)

        return hex
    }
}
