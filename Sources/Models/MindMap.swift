import Foundation
import SwiftData

@Model
final class MindMap {
    var id: UUID
    var title: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \MindMapNode.mindMap)
    var nodes: [MindMapNode]

    @Relationship(deleteRule: .cascade, inverse: \MindMapConnection.mindMap)
    var connections: [MindMapConnection]

    @Relationship(inverse: \Theme.mindMap)
    var theme: Theme?

    init(title: String = "Untitled") {
        self.id = UUID()
        self.title = title
        self.createdAt = Date()
        self.updatedAt = Date()
        self.nodes = []
        self.connections = []
    }

    var rootNode: MindMapNode? {
        nodes.first { $0.parentId == nil }
    }

    func markModified() {
        updatedAt = Date()
    }
}
