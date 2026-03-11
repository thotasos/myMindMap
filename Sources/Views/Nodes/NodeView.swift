import SwiftUI

struct NodeView: View {
    let node: MindMapNode
    @Bindable var canvasViewModel: CanvasViewModel
    @Bindable var nodeViewModel: NodeViewModel
    let isSelected: Bool
    let isEditing: Bool

    @State private var isDragging: Bool = false
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        ZStack {
            // Node background
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: node.backgroundColorHex) ?? Color.white)
                .shadow(
                    color: isSelected ? .blue.opacity(0.3) : .black.opacity(0.1),
                    radius: isSelected ? 8 : 4,
                    x: 0,
                    y: 2
                )

            // Selection ring
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            }

            // Node content
            if isEditing {
                NodeEditorView(
                    node: node,
                    nodeViewModel: nodeViewModel
                )
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    Text(node.text)
                        .font(.system(size: node.fontSize))
                        .foregroundColor(Color(hex: node.textColorHex) ?? .black)
                        .lineLimit(3)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                }
            }

            // Collapse indicator
            if node.isCollapsed && !node.children.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(node.children.count)")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Circle().fill(Color.blue))
                    }
                }
                .offset(x: node.width / 2 - 10, y: -node.height / 2 + 10)
            }
        }
        .frame(width: node.width, height: node.height)
        .contentShape(Rectangle())
        .onTapGesture {
            canvasViewModel.selectNode(node.id)
        }
        .onTapGesture(count: 2) {
            canvasViewModel.selectNode(node.id)
            nodeViewModel.startEditing(node)
        }
        .gesture(dragGesture)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true
                dragOffset = value.translation
            }
            .onEnded { value in
                isDragging = false
                let delta = CGPoint(
                    x: value.translation.width / canvasViewModel.scale,
                    y: value.translation.height / canvasViewModel.scale
                )
                nodeViewModel.moveNode(node, by: delta)
                dragOffset = .zero
            }
    }
}

// MARK: - Node Editor

struct NodeEditorView: View {
    let node: MindMapNode
    @Bindable var nodeViewModel: NodeViewModel

    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("Node text", text: $nodeViewModel.editText)
            .textFieldStyle(.plain)
            .font(.system(size: node.fontSize))
            .foregroundColor(Color(hex: node.textColorHex) ?? .black)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .focused($isFocused)
            .onAppear {
                isFocused = true
            }
            .onSubmit {
                nodeViewModel.finishEditing(node)
            }
            .onExitCommand {
                nodeViewModel.cancelEditing()
            }
    }
}
