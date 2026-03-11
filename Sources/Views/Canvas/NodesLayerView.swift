import SwiftUI

struct NodesLayerView: View {
    let mindMap: MindMap
    @Bindable var canvasViewModel: CanvasViewModel
    @Bindable var nodeViewModel: NodeViewModel

    var body: some View {
        ForEach(visibleNodes) { node in
            NodeView(
                node: node,
                canvasViewModel: canvasViewModel,
                nodeViewModel: nodeViewModel,
                isSelected: canvasViewModel.selectedNodeIDs.contains(node.id),
                isEditing: nodeViewModel.editingNodeID == node.id
            )
            .position(node.position)
        }
    }

    private var visibleNodes: [MindMapNode] {
        // Simple visibility check - in production, use viewport culling
        mindMap.nodes.filter { node in
            // Show root always
            if node.parent == nil { return true }

            // Check if any ancestor is collapsed
            var current: MindMapNode? = node
            while let parent = current?.parent {
                if parent.isCollapsed { return false }
                current = parent
            }

            return true
        }
    }
}
