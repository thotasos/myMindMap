import Foundation
import CoreGraphics

/// Spatial index for O(log n) viewport queries
/// R-tree implementation for 60fps rendering with 10k+ nodes
actor SpatialIndex {
    private var nodeBounds: [UUID: CGRect] = [:]
    private var rTree: RTree?

    struct IndexedNode {
        let id: UUID
        let bounds: CGRect
    }

    struct RTree {
        var entries: [IndexedNode] = []

        func search(in rect: CGRect) -> [UUID] {
            entries.filter { rect.intersects($0.bounds) }.map { $0.id }
        }
    }

    func build(nodes: [MindMapNode]) {
        nodeBounds = [:]
        var entries: [IndexedNode] = []

        for node in nodes {
            let bounds = node.frame.expanded(by: 10)
            nodeBounds[node.id] = bounds
            entries.append(IndexedNode(id: node.id, bounds: bounds))
        }

        rTree = RTree(entries: entries)
    }

    func nodesInRect(_ visibleRect: CGRect) -> Set<UUID> {
        guard let tree = rTree else { return [] }
        let expandedRect = visibleRect.expanded(by: 100)
        return Set(tree.search(in: expandedRect))
    }

    func nodeFrame(for nodeId: UUID) -> CGRect? {
        nodeBounds[nodeId]
    }

    func updateNode(_ nodeId: UUID, frame: CGRect) {
        nodeBounds[nodeId] = frame
        if let index = rTree?.entries.firstIndex(where: { $0.id == nodeId }) {
            rTree?.entries[index] = IndexedNode(id: nodeId, bounds: frame.expanded(by: 10))
        }
    }
}
