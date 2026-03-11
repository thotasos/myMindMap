import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var mindMapViewModel = MindMapViewModel()
    @State private var canvasViewModel = CanvasViewModel()
    @State private var nodeViewModel = NodeViewModel()
    @State private var keyboardViewModel = KeyboardViewModel()

    @State private var showSearch: Bool = false

    var body: some View {
        ZStack {
            if let mindMap = mindMapViewModel.currentMindMap {
                CanvasView(
                    mindMap: mindMap,
                    canvasViewModel: canvasViewModel,
                    nodeViewModel: nodeViewModel,
                    keyboardViewModel: keyboardViewModel
                )
            } else {
                WelcomeView(onCreateNew: createNewMindMap)
            }

            VStack {
                Spacer()
                StatusBarView(
                    mindMap: mindMapViewModel.currentMindMap,
                    canvasViewModel: canvasViewModel,
                    isDirty: mindMapViewModel.isDirty
                )
            }
        }
        .toolbar {
            ToolbarView(
                mindMapViewModel: mindMapViewModel,
                canvasViewModel: canvasViewModel
            )
        }
        .onAppear {
            setupViewModels()
            mindMapViewModel.loadRecentMindMaps()

            // Create a new mind map if none exists
            if mindMapViewModel.currentMindMap == nil && !mindMapViewModel.recentMindMaps.isEmpty {
                mindMapViewModel.openMindMap(mindMapViewModel.recentMindMaps.first!)
            } else if mindMapViewModel.currentMindMap == nil {
                createNewMindMap()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .createNewMindMap)) { _ in
            createNewMindMap()
        }
        .onReceive(NotificationCenter.default.publisher(for: .saveMindMap)) { _ in
            mindMapViewModel.saveMindMap()
        }
        .onReceive(NotificationCenter.default.publisher(for: .zoomIn)) { _ in
            canvasViewModel.zoomIn()
        }
        .onReceive(NotificationCenter.default.publisher(for: .zoomOut)) { _ in
            canvasViewModel.zoomOut()
        }
        .onReceive(NotificationCenter.default.publisher(for: .fitToScreen)) { _ in
            if let mindMap = mindMapViewModel.currentMindMap {
                canvasViewModel.fitToScreen(nodes: mindMap.nodes, viewSize: NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600))
            }
        }
        .sheet(isPresented: $showSearch) {
            SearchOverlayView(mindMap: mindMapViewModel.currentMindMap, canvasViewModel: canvasViewModel)
        }
        .onReceive(NotificationCenter.default.publisher(for: .showSearch)) { _ in
            showSearch = true
        }
    }

    private func setupViewModels() {
        mindMapViewModel.setModelContext(modelContext)
        nodeViewModel.setModelContext(modelContext)
    }

    private func createNewMindMap() {
        mindMapViewModel.createNewMindMap()
        canvasViewModel.resetView()
    }
}

struct WelcomeView: View {
    let onCreateNew: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("Welcome to myMindMap")
                .font(.largeTitle)
                .fontWeight(.semibold)

            Text("Create beautiful mind maps with keyboard shortcuts")
                .font(.title3)
                .foregroundStyle(.secondary)

            Button(action: onCreateNew) {
                Label("Create New Mind Map", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [MindMap.self, MindMapNode.self, NodeConnection.self, Theme.self], inMemory: true)
}
