import Foundation
import SwiftData

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
}
