import Foundation
import SwiftData

@Model
final class MindMapNode {
    var id: UUID
    var text: String
    var positionX: Double
    var positionY: Double
    var width: Double
    var height: Double
    var backgroundColorHex: String
    var textColorHex: String
    var fontSize: Double
    var isCollapsed: Bool
    var createdAt: Date

    var parent: MindMapNode?

    @Relationship(deleteRule: .cascade, inverse: \MindMapNode.parent)
    var children: [MindMapNode]

    @Relationship(deleteRule: .nullify)
    var mindMap: MindMap?

    @Relationship(deleteRule: .nullify)
    var outgoingConnections: [NodeConnection]

    @Relationship(deleteRule: .nullify)
    var incomingConnections: [NodeConnection]

    init(
        text: String = "New Node",
        positionX: Double = 0,
        positionY: Double = 0
    ) {
        self.id = UUID()
        self.text = text
        self.positionX = positionX
        self.positionY = positionY
        self.width = 120
        self.height = 40
        self.backgroundColorHex = "#FFFFFF"
        self.textColorHex = "#000000"
        self.fontSize = 14
        self.isCollapsed = false
        self.createdAt = Date()
        self.children = []
        self.outgoingConnections = []
        self.incomingConnections = []
    }

    var position: CGPoint {
        get { CGPoint(x: positionX, y: positionY) }
        set {
            positionX = newValue.x
            positionY = newValue.y
        }
    }

    var frame: CGRect {
        CGRect(
            x: positionX - width / 2,
            y: positionY - height / 2,
            width: width,
            height: height
        )
    }
}
