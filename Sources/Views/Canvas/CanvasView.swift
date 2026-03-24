import SwiftUI
import AppKit

struct CanvasView: View {
    let mindMap: MindMap
    @Bindable var canvasViewModel: CanvasViewModel
    @Bindable var nodeViewModel: NodeViewModel
    @Bindable var keyboardViewModel: KeyboardViewModel
    @Bindable var mindMapViewModel: MindMapViewModel

    @State private var dragOffset: CGSize = .zero
    @State private var spatialIndex = SpatialIndex()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                CanvasBackgroundView(
                    showGrid: canvasViewModel.showGrid,
                    gridSpacing: canvasViewModel.gridSpacing
                )
                .scaleEffect(canvasViewModel.scale)
                .offset(x: canvasViewModel.offset.x, y: canvasViewModel.offset.y)

                // Connections
                ConnectionsLayerView(
                    mindMap: mindMap,
                    canvasViewModel: canvasViewModel,
                    visibleNodeIds: visibleNodeIds
                )
                .scaleEffect(canvasViewModel.scale)
                .offset(x: canvasViewModel.offset.x, y: canvasViewModel.offset.y)

                // Nodes
                NodesLayerView(
                    mindMap: mindMap,
                    canvasViewModel: canvasViewModel,
                    nodeViewModel: nodeViewModel,
                    mindMapViewModel: mindMapViewModel,
                    visibleNodeIds: visibleNodeIds
                )
                .scaleEffect(canvasViewModel.scale)
                .offset(x: canvasViewModel.offset.x, y: canvasViewModel.offset.y)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .contentShape(Rectangle())
            .gesture(panGesture)
            .gesture(magnificationGesture)
            .onTapGesture {
                canvasViewModel.clearSelection()
                nodeViewModel.cancelEditing()
            }
            .onAppear {
                canvasViewModel.canvasSize = geometry.size
                Task {
                    await spatialIndex.build(nodes: mindMap.nodes)
                }
            }
            .onChange(of: geometry.size) { _, newSize in
                canvasViewModel.canvasSize = newSize
            }
            .onChange(of: mindMap.nodes.count) { _, _ in
                Task {
                    await spatialIndex.build(nodes: mindMap.nodes)
                }
            }
            .focusable()
            .onKeyPress { keyPress in
                handleKeyPress(keyPress)
            }
        }
    }

    private var visibleNodeIds: Set<UUID> {
        // Use viewport culling
        let visibleRect = canvasViewModel.visibleRect
        // For now, return all visible nodes based on expansion state
        return mindMapViewModel.visibleNodeIds
    }

    private var panGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                canvasViewModel.offset = CGPoint(
                    x: canvasViewModel.offset.x + value.translation.width - dragOffset.width,
                    y: canvasViewModel.offset.y + value.translation.height - dragOffset.height
                )
                dragOffset = CGSize(
                    width: value.translation.width,
                    height: value.translation.height
                )
            }
            .onEnded { _ in
                dragOffset = .zero
            }
    }

    private var magnificationGesture: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                let newScale = canvasViewModel.scale * value.magnification
                canvasViewModel.scale = min(max(newScale, canvasViewModel.minScale), canvasViewModel.maxScale)
            }
    }

    private func handleKeyPress(_ keyPress: KeyPress) -> KeyPress.Result {
        let key = keyPress.key
        let modifiers = keyPress.modifiers

        // Get selected node
        guard let selectedID = canvasViewModel.selectedNodeIDs.first,
              let selectedNode = mindMap.nodes.first(where: { $0.id == selectedID }) else {
            // Handle global shortcuts
            return handleGlobalShortcut(key, modifiers: modifiers)
        }

        switch (key, modifiers) {
        case (.tab, []):
            // Add child node
            let newNode = nodeViewModel.addChildNode(to: selectedNode, in: mindMap)
            mindMapViewModel.expandedNodeIds.insert(newNode.id)
            canvasViewModel.selectNode(newNode.id)
            nodeViewModel.startEditing(newNode)
            return .handled

        case (.return, []):
            if nodeViewModel.editingNodeId == selectedID {
                nodeViewModel.finishEditing(selectedNode)
            } else if selectedNode.parentId != nil {
                let newNode = nodeViewModel.addSiblingNode(to: selectedNode, in: mindMap)
                if let newNode = newNode {
                    canvasViewModel.selectNode(newNode.id)
                    nodeViewModel.startEditing(newNode)
                }
            } else {
                nodeViewModel.startEditing(selectedNode)
            }
            return .handled

        case (.delete, []):
            nodeViewModel.deleteNode(selectedNode, in: mindMap)
            canvasViewModel.clearSelection()
            return .handled

        case (.escape, []):
            if nodeViewModel.editingNodeId == selectedID {
                nodeViewModel.cancelEditing()
            } else {
                canvasViewModel.clearSelection()
                mindMapViewModel.isShortcutsOverlayVisible = false
                mindMapViewModel.isSearchOverlayVisible = false
            }
            return .handled

        case (.space, []):
            nodeViewModel.toggleCollapse(selectedNode, viewModel: mindMapViewModel)
            return .handled

        case (.upArrow, []):
            navigateToParentOrChild(selectedNode, direction: .up)
            return .handled

        case (.downArrow, []):
            navigateToParentOrChild(selectedNode, direction: .down)
            return .handled

        case (.leftArrow, []):
            navigateToSibling(selectedNode, direction: .left)
            return .handled

        case (.rightArrow, []):
            navigateToSibling(selectedNode, direction: .right)
            return .handled

        case (.return, .command):
            // Toggle expand/collapse
            nodeViewModel.toggleCollapse(selectedNode, viewModel: mindMapViewModel)
            return .handled

        default:
            return handleGlobalShortcut(key, modifiers: modifiers)
        }
    }

    private func handleGlobalShortcut(_ key: KeyEquivalent, modifiers: EventModifiers) -> KeyPress.Result {
        switch (key, modifiers) {
        case ("f", .command):
            mindMapViewModel.toggleSearchOverlay()
            return .handled

        case ("?", .command):
            mindMapViewModel.toggleShortcutsOverlay()
            return .handled

        case ("0", .command):
            canvasViewModel.resetView()
            return .handled

        case ("1", .command):
            canvasViewModel.zoomTo100()
            return .handled

        case ("=", .command), ("+", .command):
            canvasViewModel.zoomIn()
            return .handled

        case ("-", .command):
            canvasViewModel.zoomOut()
            return .handled

        case ("[", .command):
            _ = mindMapViewModel.navigateBack()
            if let nodeId = mindMapViewModel.selectedNodeId {
                canvasViewModel.selectNode(nodeId)
            }
            return .handled

        case ("]", .command):
            _ = mindMapViewModel.navigateForward()
            if let nodeId = mindMapViewModel.selectedNodeId {
                canvasViewModel.selectNode(nodeId)
            }
            return .handled

        case ("c", [.command, .shift]):
            mindMapViewModel.collapseAll()
            return .handled

        case ("e", [.command, .shift]):
            mindMapViewModel.expandAll()
            return .handled

        case ("d", .command):
            if let selectedID = canvasViewModel.selectedNodeIDs.first,
               let selectedNode = mindMap.nodes.first(where: { $0.id == selectedID }) {
                let newNode = nodeViewModel.duplicateNode(selectedNode, in: mindMap)
                if let newNode = newNode {
                    canvasViewModel.selectNode(newNode.id)
                }
            }
            return .handled

        case ("a", .command):
            canvasViewModel.selectAll(nodeIDs: mindMap.nodes.map { $0.id })
            return .handled

        case ("f", .control):
            mindMapViewModel.toggleFullscreen()
            return .handled

        default:
            return .ignored
        }
    }

    private func navigateToParentOrChild(_ node: MindMapNode, direction: Direction) {
        switch direction {
        case .up:
            if let parentId = node.parentId {
                canvasViewModel.selectNode(parentId)
            }
        case .down:
            if mindMapViewModel.isNodeExpanded(node.id),
               let firstChild = mindMap.nodes.first(where: { $0.parentId == node.id }) {
                canvasViewModel.selectNode(firstChild.id)
            }
        default:
            break
        }
    }

    private func navigateToSibling(_ node: MindMapNode, direction: Direction) {
        guard let parentId = node.parentId,
              let parent = mindMap.nodes.first(where: { $0.id == parentId }) else { return }

        let siblings = mindMap.nodes.filter { $0.parentId == parentId }.sorted { $0.positionX < $1.positionX }

        switch direction {
        case .left:
            if let currentIndex = siblings.firstIndex(where: { $0.id == node.id }), currentIndex > 0 {
                canvasViewModel.selectNode(siblings[currentIndex - 1].id)
            }
        case .right:
            if let currentIndex = siblings.firstIndex(where: { $0.id == node.id }), currentIndex < siblings.count - 1 {
                canvasViewModel.selectNode(siblings[currentIndex + 1].id)
            }
        default:
            break
        }
    }

    enum Direction {
        case up, down, left, right
    }
}

// MARK: - Canvas Background

struct CanvasBackgroundView: View {
    let showGrid: Bool
    let gridSpacing: CGFloat

    var body: some View {
        Canvas { context, size in
            guard showGrid else { return }

            let gridColor = Color.gray.opacity(0.1)

            // Vertical lines
            var x: CGFloat = -size.width
            while x < size.width * 2 {
                var path = Path()
                path.move(to: CGPoint(x: x, y: -size.height))
                path.addLine(to: CGPoint(x: x, y: size.height * 2))
                context.stroke(path, with: .color(gridColor), lineWidth: 0.5)
                x += gridSpacing
            }

            // Horizontal lines
            var y: CGFloat = -size.height
            while y < size.height * 2 {
                var path = Path()
                path.move(to: CGPoint(x: -size.width, y: y))
                path.addLine(to: CGPoint(x: size.width * 2, y: y))
                context.stroke(path, with: .color(gridColor), lineWidth: 0.5)
                y += gridSpacing
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
