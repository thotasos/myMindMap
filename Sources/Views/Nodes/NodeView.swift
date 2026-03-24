import SwiftUI

struct NodeView: View {
    let node: MindMapNode
    @Bindable var canvasViewModel: CanvasViewModel
    @Bindable var nodeViewModel: NodeViewModel
    @Bindable var mindMapViewModel: MindMapViewModel
    let isSelected: Bool
    let isEditing: Bool

    @State private var isDragging: Bool = false
    @State private var dragOffset: CGSize = .zero

    private let cornerRadius: CGFloat = 8

    var body: some View {
        ZStack {
            // Node background
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(nodeBackgroundColor)
                .shadow(
                    color: isSelected ? .blue.opacity(0.4) : .black.opacity(0.15),
                    radius: isSelected ? 10 : 5,
                    x: 0,
                    y: 2
                )

            // Selection ring
            if isSelected {
                RoundedRectangle(cornerRadius: cornerRadius + 2)
                    .stroke(Color(hex: "#007AFF")!, lineWidth: 2)
            }

            // Node content
            if isEditing {
                NodeEditorView(
                    node: node,
                    nodeViewModel: nodeViewModel
                )
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    // Title
                    Text(node.title)
                        .font(.system(size: node.fontSize, weight: .semibold))
                        .foregroundColor(titleColor)
                        .lineLimit(2)
                        .padding(.horizontal, 12)
                        .padding(.top, 8)

                    // Notes (2 lines visible)
                    if !node.notes.isEmpty {
                        Text(node.notes)
                            .font(.system(size: 10, design: .serif).italic())
                            .foregroundColor(notesColor)
                            .lineLimit(2)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 6)
                    } else {
                        Spacer()
                            .padding(.bottom, 6)
                    }
                }
            }

            // Collapse indicator
            if !node.isExpanded && !node.children.isEmpty {
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
                .offset(x: node.frame.width / 2 - 10, y: -node.frame.height / 2 + 10)
            }

            // Expand/collapse chevron for nodes with children
            if !node.children.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: node.isExpanded ? "chevron.down" : "chevron.right")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(4)
                    }
                }
                .offset(x: node.frame.width / 2 - 14, y: node.frame.height / 2 - 14)
            }
        }
        .frame(width: node.frame.width, height: node.frame.height)
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

    private var nodeBackgroundColor: Color {
        Color(hue: node.colorHue, saturation: 0.15, brightness: 0.95)
    }

    private var titleColor: Color {
        Color(hue: node.colorHue, saturation: 0.3, brightness: 0.2)
    }

    private var notesColor: Color {
        Color(hue: node.colorHue, saturation: 0.3, brightness: 0.5)
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

    @State private var isNotesFocused: Bool = false
    @FocusState private var titleFocused: Bool
    @FocusState private var notesFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            TextField("Title", text: $nodeViewModel.editText)
                .textFieldStyle(.plain)
                .font(.system(size: node.fontSize, weight: .semibold))
                .foregroundColor(Color(hue: node.colorHue, saturation: 0.3, brightness: 0.2))
                .padding(.horizontal, 12)
                .padding(.top, 8)
                .focused($titleFocused)
                .onAppear {
                    titleFocused = true
                }

            TextField("Notes", text: $nodeViewModel.editNotes)
                .textFieldStyle(.plain)
                .font(.system(size: 10, design: .serif).italic())
                .foregroundColor(Color(hue: node.colorHue, saturation: 0.3, brightness: 0.5))
                .lineLimit(2)
                .padding(.horizontal, 12)
                .padding(.bottom, 6)
                .focused($notesFocused)
                .onSubmit {
                    nodeViewModel.finishEditing(node)
                }
        }
        .onSubmit(of: .text) {
            if titleFocused && !nodeViewModel.editNotes.isEmpty {
                notesFocused = true
            }
        }
        .onExitCommand {
            nodeViewModel.cancelEditing()
        }
    }
}
