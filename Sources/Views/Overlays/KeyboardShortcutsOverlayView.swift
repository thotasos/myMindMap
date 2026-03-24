import SwiftUI

struct KeyboardShortcutsOverlayView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Keyboard Shortcuts")
                    .font(.headline)
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding()

            Divider()

            // Shortcuts list
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    shortcutsSection("File", shortcuts: fileShortcuts)
                    shortcutsSection("Edit", shortcuts: editShortcuts)
                    shortcutsSection("Navigation", shortcuts: navigationShortcuts)
                    shortcutsSection("Node", shortcuts: nodeShortcuts)
                    shortcutsSection("View", shortcuts: viewShortcuts)
                }
                .padding()
            }
        }
        .frame(width: 450, height: 400)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 20)
    }

    private func shortcutsSection(_ title: String, shortcuts: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            ForEach(shortcuts, id: \.0) { shortcut, description in
                HStack {
                    Text(shortcut)
                        .font(.system(size: 11, design: .monospaced))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 4))

                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.primary)

                    Spacer()
                }
            }
        }
    }

    private var fileShortcuts: [(String, String)] {
        [
            ("Cmd+N", "New Mind Map"),
            ("Cmd+O", "Open"),
            ("Cmd+S", "Save"),
            ("Cmd+Shift+S", "Save As"),
            ("Cmd+W", "Close")
        ]
    }

    private var editShortcuts: [(String, String)] {
        [
            ("Cmd+Z", "Undo"),
            ("Cmd+Shift+Z", "Redo"),
            ("Cmd+X", "Cut"),
            ("Cmd+C", "Copy"),
            ("Cmd+V", "Paste"),
            ("Cmd+A", "Select All"),
            ("Cmd+Backspace", "Delete Node"),
            ("Cmd+D", "Duplicate Node")
        ]
    }

    private var navigationShortcuts: [(String, String)] {
        [
            ("Cmd+[", "Navigate Back"),
            ("Cmd+]", "Navigate Forward"),
            ("Up/Down/Left/Right", "Navigate Nodes"),
            ("Cmd+F", "Search Nodes")
        ]
    }

    private var nodeShortcuts: [(String, String)] {
        [
            ("Tab", "Add Child Node"),
            ("Cmd+Return", "Add Sibling Node"),
            ("Return/Enter", "Edit Node"),
            ("Escape", "Cancel Edit"),
            ("Space", "Toggle Expand/Collapse"),
            ("Cmd+Shift+C", "Collapse All"),
            ("Cmd+Shift+E", "Expand All")
        ]
    }

    private var viewShortcuts: [(String, String)] {
        [
            ("Cmd++", "Zoom In"),
            ("Cmd+-", "Zoom Out"),
            ("Cmd+1", "Zoom to 100%"),
            ("Cmd+0", "Reset View"),
            ("Ctrl+Cmd+F", "Toggle Fullscreen"),
            ("Cmd+?", "Show Shortcuts")
        ]
    }
}
