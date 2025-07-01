import SwiftUI

// MARK: - Design System Colors
extension Color {
    static let payraBackground = Color(hex: "#FFFFFF")
    static let payraSurface = Color(hex: "#F7F8FA")
    static let payraPrimary = Color(hex: "#1570EF")
    static let payraAccent = Color(hex: "#0052FF")
    static let payraTextPrimary = Color(hex: "#111827")
    static let payraTextSecondary = Color(hex: "#6B7280")
    static let payraIcon = Color(hex: "#374151")
    static let payraIconSecondary = Color(hex: "#9CA3AF")
    static let payraError = Color(hex: "#EF4444")
    static let payraChartLine = Color(hex: "#0052FF")
    static let payraChartFill = Color(hex: "#0052FF").opacity(0.1)
    static let payraCalloutBackground = Color(hex: "#F0F2F5")
}

// MARK: - Design System Typography
extension Font {
    static let payraHeadlineLarge = Font.system(size: 34, weight: .bold, design: .default)
    static let payraHeadlineMedium = Font.system(size: 28, weight: .semibold, design: .default)
    static let payraBodyLarge = Font.system(size: 17, weight: .regular, design: .default)
    static let payraBodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    static let payraBodySmall = Font.system(size: 13, weight: .regular, design: .default)
    static let payraCaption = Font.system(size: 12, weight: .regular, design: .default)
    static let payraButton = Font.system(size: 17, weight: .semibold, design: .default)
}

// MARK: - Design System Spacing
extension CGFloat {
    static let payraSpacingXS: CGFloat = 4
    static let payraSpacingSM: CGFloat = 8
    static let payraSpacingMD: CGFloat = 16
    static let payraSpacingLG: CGFloat = 24
    static let payraSpacingXL: CGFloat = 32
}

// MARK: - Design System Radii
extension CGFloat {
    static let payraRadiusSmall: CGFloat = 4
    static let payraRadiusDefault: CGFloat = 8
    static let payraRadiusLarge: CGFloat = 16
    static let payraRadiusPill: CGFloat = 9999
}

// MARK: - Design System Shadows
extension View {
    func payraCardShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.05),
            radius: 4,
            x: 0,
            y: 2
        )
    }
}

// MARK: - Design System Components
struct PayraButton: View {
    enum Style {
        case primary
        case secondary
    }
    
    let title: String
    let style: Style
    let action: () -> Void
    
    init(_ title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.payraButton)
                .foregroundColor(style == .primary ? .payraBackground : .payraTextPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: .payraRadiusPill)
                        .fill(style == .primary ? Color.payraAccent : Color.payraSurface)
                )
        }
    }
}

struct PayraCard: View {
    let content: AnyView
    
    init<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
    }
    
    var body: some View {
        content
            .padding(.payraSpacingMD)
            .background(Color.payraBackground)
            .cornerRadius(.payraRadiusDefault)
            .payraCardShadow()
    }
}

struct PayraSearchBar: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.payraIconSecondary)
                .font(.system(size: 16))
            
            TextField(placeholder, text: $text)
                .font(.payraBodyMedium)
                .foregroundColor(.payraTextPrimary)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.payraIconSecondary)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, .payraSpacingMD)
        .frame(height: 36)
        .background(Color.payraSurface)
        .cornerRadius(.payraRadiusPill)
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 