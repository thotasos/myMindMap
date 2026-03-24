import SwiftUI

struct StatusBarView: View {
    let mindMap: MindMap?
    @Bindable var canvasViewModel: CanvasViewModel
    @Bindable var mindMapViewModel: MindMapViewModel
    let isDirty: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Breadcrumb trail
            breadcrumbTrail

            Spacer()

            // Node count
            if let mindMap = mindMap {
                Label("\(mindMap.nodes.count) nodes", systemImage: "circle.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()
                .frame(height: 12)

            // Zoom level
            Label("\(Int(canvasViewModel.scale * 100))%", systemImage: "magnifyingglass")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()
                .frame(height: 12)

            // Save status
            if isDirty {
                Label("Unsaved", systemImage: "exclamationmark.circle")
                    .font(.caption)
                    .foregroundStyle(.orange)
            } else {
                Label("Saved", systemImage: "checkmark.circle")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
    }

    @ViewBuilder
    private var breadcrumbTrail: some View {
        HStack(spacing: 4) {
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(.tertiary)

            if let mindMap = mindMap,
               let selectedId = mindMapViewModel.selectedNodeId,
               let selectedNode = mindMap.nodes.first(where: { $0.id == selectedId }) {
                let path = buildBreadcrumbPath(for: selectedNode, in: mindMap)
                ForEach(Array(path.enumerated()), id: \.offset) { index, node in
                    if index > 0 {
                        Text(" > ")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    Text(node.title)
                        .font(.caption)
                        .fontWeight(node.depth == 0 ? .semibold : .regular)
                        .foregroundStyle(node.depth == 0 ? .primary : .secondary)
                        .lineLimit(1)
                }
            } else if let mindMap = mindMap, let rootNode = mindMap.rootNode {
                Text(rootNode.title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
    }

    private func buildBreadcrumbPath(for node: MindMapNode, in mindMap: MindMap) -> [MindMapNode] {
        var path: [MindMapNode] = []
        var current: MindMapNode? = node

        while let c = current {
            path.insert(c, at: 0)
            if let parentId = c.parentId {
                current = mindMap.nodes.first { $0.id == parentId }
            } else {
                current = nil
            }
        }

        return path
    }
}
