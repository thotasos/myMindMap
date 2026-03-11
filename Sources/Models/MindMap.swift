import Foundation
import SwiftData

@Model
final class MindMap {
    var id: UUID
    var title: String
    var createdAt: Date
    var modifiedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \MindMapNode.mindMap)
    var nodes: [MindMapNode]

    @Relationship(deleteRule: .cascade, inverse: \NodeConnection.mindMap)
    var connections: [NodeConnection]

    @Relationship(inverse: \Theme.mindMap)
    var theme: Theme?

    init(title: String = "Untitled Mind Map") {
        self.id = UUID()
        self.title = title
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.nodes = []
        self.connections = []
    }

    var rootNode: MindMapNode? {
        nodes.first { $0.parent == nil }
    }

    func markModified() {
        modifiedAt = Date()
    }
}
