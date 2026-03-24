import SwiftUI

struct NodesLayerView: View {
    let mindMap: MindMap
    @Bindable var canvasViewModel: CanvasViewModel
    @Bindable var nodeViewModel: NodeViewModel
    @Bindable var mindMapViewModel: MindMapViewModel
    let visibleNodeIds: Set<UUID>

    var body: some View {
        ForEach(visibleNodes) { node in
            NodeView(
                node: node,
                canvasViewModel: canvasViewModel,
                nodeViewModel: nodeViewModel,
                mindMapViewModel: mindMapViewModel,
                isSelected: canvasViewModel.selectedNodeIDs.contains(node.id),
                isEditing: nodeViewModel.editingNodeId == node.id
            )
            .position(node.position)
        }
    }

    private var visibleNodes: [MindMapNode] {
        // Filter to only visible nodes based on:
        // 1. Node must be in visibleNodeIds set (expansion state)
        // 2. Node must intersect visible rect (viewport culling)
        let visibleRect = canvasViewModel.visibleRect

        return mindMap.nodes.filter { node in
            guard visibleNodeIds.contains(node.id) else { return false }

            // Check if node intersects visible rect with margin
            let margin: CGFloat = 200
            let expandedRect = visibleRect.insetBy(dx: -margin, dy: -margin)
            return expandedRect.intersects(node.frame)
        }
    }
}
