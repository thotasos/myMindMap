import Foundation
import SwiftData
import SwiftUI

@Model
final class Theme: Equatable {
    var id: UUID
    var name: String
    var backgroundColorHex: String
    var nodeBackgroundColorHex: String
    var nodeTextColorHex: String
    var connectionColorHex: String
    var isDarkMode: Bool
    var isDefault: Bool

    @Relationship(deleteRule: .nullify)
    var mindMap: MindMap?

    init(
        name: String,
        backgroundColorHex: String,
        nodeBackgroundColorHex: String,
        nodeTextColorHex: String,
        connectionColorHex: String,
        isDarkMode: Bool,
        isDefault: Bool
    ) {
        self.id = UUID()
        self.name = name
        self.backgroundColorHex = backgroundColorHex
        self.nodeBackgroundColorHex = nodeBackgroundColorHex
        self.nodeTextColorHex = nodeTextColorHex
        self.connectionColorHex = connectionColorHex
        self.isDarkMode = isDarkMode
        self.isDefault = isDefault
    }

    static var defaultLight: Theme {
        Theme(
            name: "Light",
            backgroundColorHex: "#FFFFFF",
            nodeBackgroundColorHex: "#F5F5F5",
            nodeTextColorHex: "#000000",
            connectionColorHex: "#888888",
            isDarkMode: false,
            isDefault: true
        )
    }

    static var defaultDark: Theme {
        Theme(
            name: "Dark",
            backgroundColorHex: "#1E1E1E",
            nodeBackgroundColorHex: "#2D2D2D",
            nodeTextColorHex: "#FFFFFF",
            connectionColorHex: "#666666",
            isDarkMode: true,
            isDefault: true
        )
    }
}

// MARK: - Theme Colors

extension Theme {
    var nodeBackgroundColor: Color {
        Color(hex: nodeBackgroundColorHex) ?? .gray
    }

    var nodeTextColor: Color {
        Color(hex: nodeTextColorHex) ?? .primary
    }

    var backgroundColor: Color {
        Color(hex: backgroundColorHex) ?? .white
    }

    var connectionColor: Color {
        Color(hex: connectionColorHex) ?? .gray
    }

    // 8 distinct HSB hues for connectors
    static let connectorHues: [Double] = [
        0.0,    // Red
        0.125,  // Orange
        0.25,   // Yellow
        0.375,  // Green
        0.5,    // Cyan
        0.625,  // Blue
        0.75,   // Purple
        0.875   // Magenta
    ]

    static func connectorColor(at index: Int) -> Color {
        let hue = connectorHues[index % connectorHues.count]
        return Color(hue: hue, saturation: 1.0, brightness: 0.7)
    }
}
