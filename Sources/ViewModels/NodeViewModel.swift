import Foundation
import SwiftUI
import SwiftData

@Observable
class NodeViewModel {
    var editingNodeID: UUID?
    var editText: String = ""
    var clipboard: String = ""

    var modelContext: ModelContext?

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // MARK: - Node Creation

    func addChildNode(to node: MindMapNode, in mindMap: MindMap) -> MindMapNode {
        let childCount = node.children.count
        let offset: CGFloat = 150
        let verticalSpacing: CGFloat = 60

        let newNode = MindMapNode(
            text: "New Idea",
            positionX: node.positionX + offset,
            positionY: node.positionY + (CGFloat(childCount) - CGFloat(node.children.count - 1) / 2) * verticalSpacing
        )

        newNode.parent = node
        newNode.mindMap = mindMap

        // Create connection
        let connection = NodeConnection(source: node, target: newNode)
        connection.mindMap = mindMap

        node.children.append(newNode)
        mindMap.nodes.append(newNode)
        mindMap.connections.append(connection)

        mindMap.markModified()
        try? modelContext?.save()

        return newNode
    }

    func addSiblingNode(to node: MindMapNode, in mindMap: MindMap) -> MindMapNode? {
        guard let parent = node.parent else { return nil }

        let siblingCount = parent.children.count
        let offset: CGFloat = 150

        let newNode = MindMapNode(
            text: "New Idea",
            positionX: node.positionX + offset,
            positionY: node.positionY
        )

        newNode.parent = parent
        newNode.mindMap = mindMap

        // Create connection
        let connection = NodeConnection(source: parent, target: newNode)
        connection.mindMap = mindMap

        parent.children.append(newNode)
        mindMap.nodes.append(newNode)
        mindMap.connections.append(connection)

        mindMap.markModified()
        try? modelContext?.save()

        return newNode
    }

    // MARK: - Node Deletion

    func deleteNode(_ node: MindMapNode, in mindMap: MindMap) {
        guard node.parent != nil || mindMap.rootNode?.id != node.id else { return }

        // Delete all children recursively
        deleteNodeAndChildren(node, in: mindMap)

        mindMap.markModified()
        try? modelContext?.save()
    }

    private func deleteNodeAndChildren(_ node: MindMapNode, in mindMap: MindMap) {
        for child in node.children {
            deleteNodeAndChildren(child, in: mindMap)
        }

        // Remove connections
        mindMap.connections.removeAll { connection in
            connection.sourceNode?.id == node.id || connection.targetNode?.id == node.id
        }

        // Remove from parent's children
        if let parent = node.parent {
            parent.children.removeAll { $0.id == node.id }
        }

        // Remove from mind map
        mindMap.nodes.removeAll { $0.id == node.id }

        // Delete the node
        modelContext?.delete(node)
    }

    // MARK: - Node Editing

    func startEditing(_ node: MindMapNode) {
        editingNodeID = node.id
        editText = node.text
    }

    func finishEditing(_ node: MindMapNode) {
        guard editingNodeID == node.id else { return }

        node.text = editText
        editingNodeID = nil

        node.mindMap?.markModified()
        try? modelContext?.save()
    }

    func cancelEditing() {
        editingNodeID = nil
        editText = ""
    }

    // MARK: - Node Movement

    func moveNode(_ node: MindMapNode, by delta: CGPoint) {
        node.position = CGPoint(
            x: node.positionX + delta.x,
            y: node.positionY + delta.y
        )

        node.mindMap?.markModified()
    }

    func moveNodeTo(_ node: MindMapNode, position: CGPoint) {
        node.position = position

        node.mindMap?.markModified()
    }

    // MARK: - Collapse/Expand

    func toggleCollapse(_ node: MindMapNode) {
        node.isCollapsed.toggle()

        node.mindMap?.markModified()
        try? modelContext?.save()
    }

    // MARK: - Node Duplication

    func duplicateNode(_ node: MindMapNode, in mindMap: MindMap) -> MindMapNode? {
        guard let parent = node.parent else { return nil }

        let newNode = MindMapNode(
            text: node.text + " (copy)",
            positionX: node.positionX + 50,
            positionY: node.positionY + 50
        )

        newNode.parent = parent
        newNode.mindMap = mindMap
        newNode.backgroundColorHex = node.backgroundColorHex
        newNode.textColorHex = node.textColorHex
        newNode.fontSize = node.fontSize

        // Copy children recursively
        duplicateChildren(from: node, to: newNode, in: mindMap)

        // Create connection
        let connection = NodeConnection(source: parent, target: newNode)
        connection.mindMap = mindMap

        parent.children.append(newNode)
        mindMap.nodes.append(newNode)
        mindMap.connections.append(connection)

        mindMap.markModified()
        try? modelContext?.save()

        return newNode
    }

    private func duplicateChildren(from source: MindMapNode, to target: MindMapNode, in mindMap: MindMap) {
        for child in source.children {
            let newChild = MindMapNode(
                text: child.text,
                positionX: child.positionX,
                positionY: child.positionY
            )

            newChild.parent = target
            newChild.mindMap = mindMap
            newChild.backgroundColorHex = child.backgroundColorHex
            newChild.textColorHex = child.textColorHex
            newChild.fontSize = child.fontSize

            target.children.append(newChild)
            mindMap.nodes.append(newChild)

            let connection = NodeConnection(source: target, target: newChild)
            connection.mindMap = mindMap
            mindMap.connections.append(connection)

            duplicateChildren(from: child, to: newChild, in: mindMap)
        }
    }
}
