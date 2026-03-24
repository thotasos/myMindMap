import Foundation
import SwiftUI
import SwiftData

@Observable
@MainActor
final class NodeViewModel {
    // MARK: - Editing State
    var editingNodeId: UUID?
    var editText: String = ""
    var editNotes: String = ""

    // MARK: - Clipboard
    var clipboard: String = ""

    // MARK: - Constants
    static let maxTitleLength = 10000
    static let maxNotesLength = 10000

    // MARK: - Private
    private(set) var modelContext: ModelContext?

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // MARK: - Node Creation

    func addChildNode(to node: MindMapNode, in mindMap: MindMap) -> MindMapNode {
        let childCount = node.children.count

        // Calculate radial position
        let distance: CGFloat = 150
        let angle = (Double(childCount) * .pi / 4) - .pi / 2

        let newNode = MindMapNode(
            title: "New Idea",
            notes: "",
            positionX: node.positionX + cos(angle) * distance,
            positionY: node.positionY + sin(angle) * distance,
            depth: node.depth + 1,
            isExpanded: true,
            parentId: node.id,
            colorHue: Double(childCount % 8) / 8.0,
            colorSaturation: 1.0,
            colorBrightness: 0.7
        )

        newNode.mindMap = mindMap

        // Create connection
        let connection = MindMapConnection(
            sourceNodeId: node.id,
            targetNodeId: newNode.id,
            colorHue: newNode.colorHue,
            colorSaturation: newNode.colorSaturation,
            colorBrightness: newNode.colorBrightness
        )
        connection.mindMap = mindMap

        mindMap.nodes.append(newNode)
        mindMap.connections.append(connection)

        mindMap.markModified()
        try? modelContext?.save()

        return newNode
    }

    func addSiblingNode(to node: MindMapNode, in mindMap: MindMap) -> MindMapNode? {
        guard let parentId = node.parentId,
              let parent = mindMap.nodes.first(where: { $0.id == parentId }) else {
            return nil
        }

        let siblingCount = parent.children.count
        let offset: CGFloat = 150

        let newNode = MindMapNode(
            title: "New Idea",
            notes: "",
            positionX: node.positionX + offset,
            positionY: node.positionY,
            depth: node.depth,
            isExpanded: true,
            parentId: parentId,
            colorHue: Double(siblingCount % 8) / 8.0,
            colorSaturation: 1.0,
            colorBrightness: 0.7
        )

        newNode.mindMap = mindMap

        // Create connection
        let connection = MindMapConnection(
            sourceNodeId: parentId,
            targetNodeId: newNode.id,
            colorHue: newNode.colorHue,
            colorSaturation: newNode.colorSaturation,
            colorBrightness: newNode.colorBrightness
        )
        connection.mindMap = mindMap

        mindMap.nodes.append(newNode)
        mindMap.connections.append(connection)

        mindMap.markModified()
        try? modelContext?.save()

        return newNode
    }

    // MARK: - Node Deletion

    func deleteNode(_ node: MindMapNode, in mindMap: MindMap) {
        // Don't delete root node
        guard node.parentId != nil else { return }

        deleteNodeAndChildren(node, in: mindMap)

        mindMap.markModified()
        try? modelContext?.save()
    }

    private func deleteNodeAndChildren(_ node: MindMapNode, in mindMap: MindMap) {
        // Delete children first
        for child in node.children {
            deleteNodeAndChildren(child, in: mindMap)
        }

        // Remove connections
        mindMap.connections.removeAll { connection in
            connection.sourceNodeId == node.id || connection.targetNodeId == node.id
        }

        // Remove from parent's children list
        if let parentId = node.parentId,
           let parent = mindMap.nodes.first(where: { $0.id == parentId }) {
            parent.children.removeAll { $0.id == node.id }
        }

        // Remove from mind map
        mindMap.nodes.removeAll { $0.id == node.id }

        // Delete the node
        modelContext?.delete(node)
    }

    // MARK: - Node Editing

    func startEditing(_ node: MindMapNode) {
        editingNodeId = node.id
        editText = node.title
        editNotes = node.notes
    }

    func finishEditing(_ node: MindMapNode) {
        guard editingNodeId == node.id else { return }

        // Validate lengths
        let truncatedTitle = String(editText.prefix(Self.maxTitleLength))
        let truncatedNotes = String(editNotes.prefix(Self.maxNotesLength))

        node.title = truncatedTitle
        node.notes = truncatedNotes
        editingNodeId = nil

        node.mindMap?.markModified()
        try? modelContext?.save()
    }

    func cancelEditing() {
        editingNodeId = nil
        editText = ""
        editNotes = ""
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

    func toggleCollapse(_ node: MindMapNode, viewModel: MindMapViewModel) {
        node.isExpanded.toggle()
        viewModel.toggleNodeExpansion(node.id)
        try? modelContext?.save()
    }

    // MARK: - Node Duplication

    func duplicateNode(_ node: MindMapNode, in mindMap: MindMap) -> MindMapNode? {
        guard let parentId = node.parentId else { return nil }

        let newNode = MindMapNode(
            title: node.title + " (copy)",
            notes: node.notes,
            positionX: node.positionX + 20,
            positionY: node.positionY + 20,
            depth: node.depth,
            isExpanded: node.isExpanded,
            parentId: parentId,
            colorHue: node.colorHue,
            colorSaturation: node.colorSaturation,
            colorBrightness: node.colorBrightness
        )

        newNode.mindMap = mindMap

        // Create connection
        let connection = MindMapConnection(
            sourceNodeId: parentId,
            targetNodeId: newNode.id,
            colorHue: newNode.colorHue,
            colorSaturation: newNode.colorSaturation,
            colorBrightness: newNode.colorBrightness
        )
        connection.mindMap = mindMap

        mindMap.nodes.append(newNode)
        mindMap.connections.append(connection)

        mindMap.markModified()
        try? modelContext?.save()

        return newNode
    }

    // MARK: - Copy/Cut/Paste

    func copyNode(_ node: MindMapNode) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(NodeCopyData(
            title: node.title,
            notes: node.notes,
            depth: node.depth
        )) {
            clipboard = String(data: data, encoding: .utf8) ?? ""
        }
    }

    func cutNode(_ node: MindMapNode, in mindMap: MindMap) {
        copyNode(node)
        deleteNode(node, in: mindMap)
    }

    func paste(in mindMap: MindMap, at position: CGPoint) -> MindMapNode? {
        guard let data = clipboard.data(using: .utf8) else { return nil }

        let decoder = JSONDecoder()
        guard let copyData = try? decoder.decode(NodeCopyData.self, from: data) else { return nil }

        let newNode = MindMapNode(
            title: copyData.title,
            notes: copyData.notes,
            positionX: position.x,
            positionY: position.y,
            depth: copyData.depth,
            isExpanded: true,
            parentId: nil,
            colorHue: 0.0,
            colorSaturation: 0.0,
            colorBrightness: 0.9
        )

        newNode.mindMap = mindMap
        mindMap.nodes.append(newNode)
        mindMap.markModified()
        try? modelContext?.save()

        return newNode
    }
}

// MARK: - Copy Data Structure

private struct NodeCopyData: Codable {
    let title: String
    let notes: String
    let depth: Int
}
