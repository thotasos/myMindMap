import Foundation
import SwiftUI

@Observable
class CanvasViewModel {
    // Viewport state
    var scale: CGFloat = 1.0
    var offset: CGPoint = .zero
    var canvasSize: CGSize = .zero

    // Selection state
    var selectedNodeIDs: Set<UUID> = []
    var focusedNodeID: UUID?

    // Canvas settings
    var showGrid: Bool = true
    var gridSpacing: CGFloat = 20

    // Animation
    var animationDuration: Double = 0.3

    // Limits
    let minScale: CGFloat = 0.1
    let maxScale: CGFloat = 3.0

    var visibleRect: CGRect {
        CGRect(
            x: -offset.x / scale,
            y: -offset.y / scale,
            width: canvasSize.width / scale,
            height: canvasSize.height / scale
        )
    }

    // MARK: - Pan & Zoom

    func zoomIn() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            scale = min(scale * 1.2, maxScale)
        }
    }

    func zoomOut() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            scale = max(scale / 1.2, minScale)
        }
    }

    func fitToScreen(nodes: [MindMapNode], viewSize: CGSize) {
        guard !nodes.isEmpty else { return }

        let padding: CGFloat = 50

        var minX = Double.greatestFiniteMagnitude
        var minY = Double.greatestFiniteMagnitude
        var maxX = -Double.greatestFiniteMagnitude
        var maxY = -Double.greatestFiniteMagnitude

        for node in nodes {
            minX = min(minX, node.positionX - node.width / 2)
            minY = min(minY, node.positionY - node.height / 2)
            maxX = max(maxX, node.positionX + node.width / 2)
            maxY = max(maxY, node.positionY + node.height / 2)
        }

        let contentWidth = maxX - minX + padding * 2
        let contentHeight = maxY - minY + padding * 2

        let scaleX = viewSize.width / contentWidth
        let scaleY = viewSize.height / contentHeight
        let newScale = min(min(scaleX, scaleY), maxScale)

        let centerX = (minX + maxX) / 2
        let centerY = (minY + maxY) / 2

        withAnimation(.easeInOut(duration: animationDuration)) {
            scale = newScale
            offset = CGPoint(
                x: viewSize.width / 2 - centerX * newScale,
                y: viewSize.height / 2 - centerY * newScale
            )
        }
    }

    func resetView() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            scale = 1.0
            offset = .zero
        }
    }

    func pan(by delta: CGPoint) {
        offset = CGPoint(
            x: offset.x + delta.x,
            y: offset.y + delta.y
        )
    }

    // MARK: - Node Hit Testing

    func nodeAt(point: CGPoint, nodes: [MindMapNode]) -> MindMapNode? {
        let canvasPoint = screenToCanvas(point)

        for node in nodes.reversed() {
            if node.frame.contains(canvasPoint) {
                return node
            }
        }
        return nil
    }

    func screenToCanvas(_ point: CGPoint) -> CGPoint {
        CGPoint(
            x: (point.x - offset.x) / scale,
            y: (point.y - offset.y) / scale
        )
    }

    func canvasToScreen(_ point: CGPoint) -> CGPoint {
        CGPoint(
            x: point.x * scale + offset.x,
            y: point.y * scale + offset.y
        )
    }

    // MARK: - Selection

    func selectNode(_ nodeID: UUID) {
        selectedNodeIDs = [nodeID]
        focusedNodeID = nodeID
    }

    func toggleSelection(_ nodeID: UUID) {
        if selectedNodeIDs.contains(nodeID) {
            selectedNodeIDs.remove(nodeID)
        } else {
            selectedNodeIDs.insert(nodeID)
        }
    }

    func clearSelection() {
        selectedNodeIDs.removeAll()
    }

    func selectAll(nodeIDs: [UUID]) {
        selectedNodeIDs = Set(nodeIDs)
    }

    var hasSelection: Bool {
        !selectedNodeIDs.isEmpty
    }
}
