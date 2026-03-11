import SwiftUI

struct StatusBarView: View {
    let mindMap: MindMap?
    @Bindable var canvasViewModel: CanvasViewModel
    let isDirty: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Node count
            if let mindMap = mindMap {
                Label("\(mindMap.nodes.count) nodes", systemImage: "circle.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Zoom level
            Label("\(Int(canvasViewModel.scale * 100))%", systemImage: "magnifyingglass")
                .font(.caption)
                .foregroundStyle(.secondary)

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
}
