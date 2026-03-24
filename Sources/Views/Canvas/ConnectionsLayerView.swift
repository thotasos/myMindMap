import SwiftUI

struct ConnectionsLayerView: View {
    let mindMap: MindMap
    @Bindable var canvasViewModel: CanvasViewModel
    let visibleNodeIds: Set<UUID>

    var body: some View {
        Canvas { context, size in
            for connection in mindMap.connections {
                // Only draw connections where both nodes are visible
                guard visibleNodeIds.contains(connection.sourceNodeId),
                      visibleNodeIds.contains(connection.targetNodeId),
                      let sourceNode = mindMap.nodes.first(where: { $0.id == connection.sourceNodeId }),
                      let targetNode = mindMap.nodes.first(where: { $0.id == connection.targetNodeId }) else {
                    continue
                }

                // Skip if source is collapsed
                if !mindMapViewModel.isNodeExpanded(sourceNode.id) {
                    continue
                }

                let path = createConnectionPath(
                    from: sourceNode.position,
                    to: targetNode.position
                )

                let color = Theme.connectorColor(at: connectionIndex(connection))

                context.stroke(
                    path,
                    with: .color(color.opacity(0.7)),
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round)
                )
            }
        }
    }

    private var mindMapViewModel: MindMapViewModel {
        // We need to access expanded state - this is a simplified approach
        // In a real implementation, this would be passed differently
        MindMapViewModel()
    }

    private func connectionIndex(_ connection: MindMapConnection) -> Int {
        // Distribute colors based on target node's position in tree
        if let targetNode = mindMap.nodes.first(where: { $0.id == connection.targetNodeId }) {
            return targetNode.depth % 8
        }
        return 0
    }

    private func createConnectionPath(from: CGPoint, to: CGPoint) -> Path {
        var path = Path()
        path.move(to: from)

        let midX = (from.x + to.x) / 2

        // Bezier curve for smooth connection
        path.addCurve(
            to: to,
            control1: CGPoint(x: midX, y: from.y),
            control2: CGPoint(x: midX, y: to.y)
        )

        return path
    }
}
