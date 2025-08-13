import SwiftUI

struct Theme {
    /// Brand/school accent (Matches the S2Pass orange (#FF9900).orange (#FF9900).
    static let schoolColor: Color = Color(red: 1.0, green: 0.6, blue: 0.0)

    /// Pick readable text (white/black) over a background color.
    static func textColor(on bg: Color) -> Color {
    #if canImport(UIKit)
        let ui = UIColor(bg)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        return luminance > 0.7 ? .black : .white
    #else
        return .white
    #endif
    }
}
