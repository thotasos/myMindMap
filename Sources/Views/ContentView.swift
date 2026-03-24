import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var mindMapViewModel = MindMapViewModel()
    @State private var canvasViewModel = CanvasViewModel()
    @State private var nodeViewModel = NodeViewModel()
    @State private var keyboardViewModel = KeyboardViewModel()

    @State private var showSearch: Bool = false
    @State private var showShortcuts: Bool = false

    var body: some View {
        ZStack {
            if let mindMap = mindMapViewModel.currentMindMap {
                // Fullscreen mode
                if mindMapViewModel.isFullscreen {
                    fullscreenCanvas(mindMap: mindMap)
                } else {
                    normalCanvas(mindMap: mindMap)
                }
            } else {
                WelcomeView(onCreateNew: createNewMindMap)
            }

            // Floating toolbar
            if mindMapViewModel.currentMindMap != nil && !mindMapViewModel.isFullscreen {
                VStack {
                    Spacer()
                    HStack {
                        FloatingToolbarView(
                            mindMapViewModel: mindMapViewModel,
                            canvasViewModel: canvasViewModel,
                            nodeViewModel: nodeViewModel
                        )
                        .padding()
                        Spacer()
                    }
                    Spacer()
                }
            }

            // Status bar
            if mindMapViewModel.currentMindMap != nil && !mindMapViewModel.isFullscreen {
                VStack {
                    Spacer()
                    StatusBarView(
                        mindMap: mindMapViewModel.currentMindMap,
                        canvasViewModel: canvasViewModel,
                        mindMapViewModel: mindMapViewModel,
                        isDirty: mindMapViewModel.isDirty
                    )
                }
            }

            // Shortcuts overlay
            if showShortcuts {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showShortcuts = false
                    }
                KeyboardShortcutsOverlayView(isPresented: $showShortcuts)
            }

            // Search overlay
            if showSearch {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showSearch = false
                    }
                SearchOverlayView(
                    mindMap: mindMapViewModel.currentMindMap,
                    canvasViewModel: canvasViewModel,
                    mindMapViewModel: mindMapViewModel
                )
            }
        }
        .onAppear {
            setupViewModels()
            mindMapViewModel.loadRecentMindMaps()

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
        .onReceive(NotificationCenter.default.publisher(for: .zoomTo100)) { _ in
            canvasViewModel.zoomTo100()
        }
        .onReceive(NotificationCenter.default.publisher(for: .fitToScreen)) { _ in
            if let mindMap = mindMapViewModel.currentMindMap {
                canvasViewModel.fitToScreen(
                    nodes: mindMap.nodes,
                    viewSize: NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600)
                )
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showSearch)) { _ in
            showSearch = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .showShortcuts)) { _ in
            showShortcuts = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateBack)) { _ in
            if let nodeId = mindMapViewModel.navigateBack() {
                canvasViewModel.selectNode(nodeId)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateForward)) { _ in
            if let nodeId = mindMapViewModel.navigateForward() {
                canvasViewModel.selectNode(nodeId)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .collapseAll)) { _ in
            mindMapViewModel.collapseAll()
        }
        .onReceive(NotificationCenter.default.publisher(for: .expandAll)) { _ in
            mindMapViewModel.expandAll()
        }
        .onReceive(NotificationCenter.default.publisher(for: .toggleFullscreen)) { _ in
            mindMapViewModel.toggleFullscreen()
        }
    }

    @ViewBuilder
    private func normalCanvas(mindMap: MindMap) -> some View {
        CanvasView(
            mindMap: mindMap,
            canvasViewModel: canvasViewModel,
            nodeViewModel: nodeViewModel,
            keyboardViewModel: keyboardViewModel,
            mindMapViewModel: mindMapViewModel
        )
    }

    @ViewBuilder
    private func fullscreenCanvas(mindMap: MindMap) -> some View {
        CanvasView(
            mindMap: mindMap,
            canvasViewModel: canvasViewModel,
            nodeViewModel: nodeViewModel,
            keyboardViewModel: keyboardViewModel,
            mindMapViewModel: mindMapViewModel
        )
        .ignoresSafeArea()
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
        .modelContainer(for: [MindMap.self, MindMapNode.self, MindMapConnection.self, Theme.self], inMemory: true)
}
