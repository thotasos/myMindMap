import SwiftUI

struct ToolbarView: ToolbarContent {
    @Bindable var mindMapViewModel: MindMapViewModel
    @Bindable var canvasViewModel: CanvasViewModel

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button(action: {
                mindMapViewModel.createNewMindMap()
            }) {
                Label("New", systemImage: "doc.badge.plus")
            }
            .help("New Mind Map (Cmd+N)")

            Divider()

            Button(action: {
                mindMapViewModel.saveMindMap()
            }) {
                Label("Save", systemImage: "square.and.arrow.down")
            }
            .help("Save (Cmd+S)")
            .disabled(mindMapViewModel.currentMindMap == nil)

            Divider()

            Menu {
                Button("Export as JSON") {
                    // Export JSON
                }
                Button("Export as Markdown") {
                    // Export Markdown
                }
                Button("Export as PNG") {
                    // Export PNG
                }
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
            }
            .disabled(mindMapViewModel.currentMindMap == nil)
        }

        ToolbarItemGroup(placement: .automatic) {
            Divider()

            Button(action: {
                canvasViewModel.zoomOut()
            }) {
                Label("Zoom Out", systemImage: "minus.magnifyingglass")
            }
            .help("Zoom Out (Cmd+-)")

            Text("\(Int(canvasViewModel.scale * 100))%")
                .frame(width: 50)
                .font(.caption)

            Button(action: {
                canvasViewModel.zoomIn()
            }) {
                Label("Zoom In", systemImage: "plus.magnifyingglass")
            }
            .help("Zoom In (Cmd++)")

            Button(action: {
                if let mindMap = mindMapViewModel.currentMindMap {
                    canvasViewModel.fitToScreen(
                        nodes: mindMap.nodes,
                        viewSize: NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600)
                    )
                }
            }) {
                Label("Fit to Screen", systemImage: "arrow.up.left.and.arrow.down.right")
            }
            .help("Fit to Screen (Cmd+0)")

            Divider()

            Button(action: {
                canvasViewModel.showGrid.toggle()
            }) {
                Label("Toggle Grid", systemImage: canvasViewModel.showGrid ? "grid" : "grid.circle")
            }
            .help("Toggle Grid")
        }
    }
}
