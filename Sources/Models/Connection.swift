import Foundation
import SwiftData

@Model
final class NodeConnection {
    var id: UUID
    var styleRawValue: String
    var colorHex: String
    var createdAt: Date

    var sourceNode: MindMapNode?
    var targetNode: MindMapNode?

    @Relationship(deleteRule: .nullify)
    var mindMap: MindMap?

    init(
        source: MindMapNode? = nil,
        target: MindMapNode? = nil,
        style: ConnectionStyle = .curved,
        colorHex: String = "#888888"
    ) {
        self.id = UUID()
        self.styleRawValue = style.rawValue
        self.colorHex = colorHex
        self.createdAt = Date()
        self.sourceNode = source
        self.targetNode = target
    }

    var style: ConnectionStyle {
        get { ConnectionStyle(rawValue: styleRawValue) ?? .curved }
        set { styleRawValue = newValue.rawValue }
    }
}

enum ConnectionStyle: String, Codable, CaseIterable {
    case straight
    case curved
    case bezier

    var displayName: String {
        switch self {
        case .straight: return "Straight"
        case .curved: return "Curved"
        case .bezier: return "Bezier"
        }
    }
}
