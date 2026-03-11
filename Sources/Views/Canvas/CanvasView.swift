import SwiftUI

struct CanvasView: View {
    let mindMap: MindMap
    @Bindable var canvasViewModel: CanvasViewModel
    @Bindable var nodeViewModel: NodeViewModel
    @Bindable var keyboardViewModel: KeyboardViewModel

    @State private var dragOffset: CGSize = .zero

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
                    canvasViewModel: canvasViewModel
                )
                .scaleEffect(canvasViewModel.scale)
                .offset(x: canvasViewModel.offset.x, y: canvasViewModel.offset.y)

                // Nodes
                NodesLayerView(
                    mindMap: mindMap,
                    canvasViewModel: canvasViewModel,
                    nodeViewModel: nodeViewModel
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
            }
            .onChange(of: geometry.size) { _, newSize in
                canvasViewModel.canvasSize = newSize
            }
            .focusable()
            .onKeyPress { keyPress in
                handleKeyPress(keyPress)
            }
        }
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
            return .ignored
        }

        switch (key, modifiers) {
        case (.tab, []):
            // Add child node
            let newNode = nodeViewModel.addChildNode(to: selectedNode, in: mindMap)
            canvasViewModel.selectNode(newNode.id)
            nodeViewModel.startEditing(newNode)
            return .handled

        case (.return, []):
            // If editing, finish editing. If not, add sibling.
            if nodeViewModel.editingNodeID == selectedID {
                nodeViewModel.finishEditing(selectedNode)
            } else if let parent = selectedNode.parent {
                let newNode = nodeViewModel.addSiblingNode(to: selectedNode, in: mindMap)
                if let newNode = newNode {
                    canvasViewModel.selectNode(newNode.id)
                    nodeViewModel.startEditing(newNode)
                }
            }
            return .handled

        case (.delete, []):
            nodeViewModel.deleteNode(selectedNode, in: mindMap)
            canvasViewModel.clearSelection()
            return .handled

        case (.escape, []):
            if nodeViewModel.editingNodeID == selectedID {
                nodeViewModel.cancelEditing()
            } else {
                canvasViewModel.clearSelection()
            }
            return .handled

        case (.upArrow, []):
            // Navigate to parent
            if let parent = selectedNode.parent {
                canvasViewModel.selectNode(parent.id)
            }
            return .handled

        case (.downArrow, []):
            // Navigate to first child if not collapsed
            if !selectedNode.isCollapsed, let firstChild = selectedNode.children.first {
                canvasViewModel.selectNode(firstChild.id)
            }
            return .handled

        case (.leftArrow, []):
            // Navigate to previous sibling
            if let parent = selectedNode.parent,
               let index = parent.children.firstIndex(where: { $0.id == selectedID }),
               index > 0 {
                canvasViewModel.selectNode(parent.children[index - 1].id)
            }
            return .handled

        case (.rightArrow, []):
            // Navigate to next sibling
            if let parent = selectedNode.parent,
               let index = parent.children.firstIndex(where: { $0.id == selectedID }),
               index < parent.children.count - 1 {
                canvasViewModel.selectNode(parent.children[index + 1].id)
            }
            return .handled

        case (.return, .command):
            // Toggle collapse
            nodeViewModel.toggleCollapse(selectedNode)
            return .handled

        default:
            return .ignored
        }
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
