import Foundation
import SwiftUI
import SwiftData
import AppKit

@Observable
@MainActor
final class MindMapViewModel {
    // MARK: - Document State
    var currentMindMap: MindMap?
    var recentMindMaps: [MindMap] = []
    var isDirty: Bool = false

    // MARK: - Selection State
    var selectedNodeId: UUID?
    var expandedNodeIds: Set<UUID> = []

    // MARK: - Canvas State
    var canvasOffset: CGPoint = .zero
    var canvasZoom: CGFloat = 1.0

    // MARK: - UI State
    var isFullscreen: Bool = false
    var isShortcutsOverlayVisible: Bool = false
    var isSearchOverlayVisible: Bool = false
    var searchQuery: String = ""

    // MARK: - Navigation
    var navigationHistory: [UUID] = []
    var historyIndex: Int = -1

    // MARK: - Private
    private(set) var modelContext: ModelContext?
    private var autoSaveTimer: Timer?
    private var needsSave: Bool = false

    // MARK: - Constants
    let minZoom: CGFloat = 0.1
    let maxZoom: CGFloat = 4.0

    // MARK: - Initialization

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // MARK: - Document Operations

    func createNewMindMap() {
        let mindMap = MindMap(title: "Untitled")

        // Create root node at center
        let rootNode = MindMapNode(
            title: "Central Idea",
            notes: "",
            positionX: 0,
            positionY: 0,
            depth: 0,
            isExpanded: true,
            parentId: nil,
            colorHue: 0.0,
            colorSaturation: 0.0,
            colorBrightness: 0.9
        )
        rootNode.mindMap = mindMap
        mindMap.nodes.append(rootNode)

        currentMindMap = mindMap
        isDirty = true
        selectedNodeId = rootNode.id
        expandedNodeIds.insert(rootNode.id)
        clearNavigationHistory()
        addToNavigationHistory(rootNode.id)

        guard let context = modelContext else { return }
        context.insert(mindMap)
        try? context.save()

        startAutoSaveTimer()
    }

    func saveMindMap() {
        guard let mindMap = currentMindMap else { return }
        mindMap.markModified()

        guard let context = modelContext else { return }
        try? context.save()

        isDirty = false
        needsSave = false
    }

    func loadRecentMindMaps() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<MindMap>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )

        do {
            let maps = try context.fetch(descriptor)
            recentMindMaps = Array(maps.prefix(10))
        } catch {
            print("Failed to fetch recent mind maps: \(error)")
        }
    }

    func openMindMap(_ mindMap: MindMap) {
        currentMindMap = mindMap
        isDirty = false
        selectedNodeId = mindMap.rootNode?.id
        clearNavigationHistory()

        if let rootId = mindMap.rootNode?.id {
            addToNavigationHistory(rootId)
        }

        // Restore expanded state
        expandedNodeIds = Set(mindMap.nodes.filter { $0.isExpanded }.map { $0.id })
    }

    func deleteMindMap(_ mindMap: MindMap) {
        guard let context = modelContext else { return }
        context.delete(mindMap)
        try? context.save()

        if currentMindMap?.id == mindMap.id {
            currentMindMap = nil
        }

        loadRecentMindMaps()
    }

    // MARK: - Node Selection

    func selectNode(_ nodeId: UUID) {
        if selectedNodeId != nodeId {
            selectedNodeId = nodeId
            addToNavigationHistory(nodeId)
        }
    }

    func toggleNodeExpansion(_ nodeId: UUID) {
        if expandedNodeIds.contains(nodeId) {
            expandedNodeIds.remove(nodeId)
        } else {
            expandedNodeIds.insert(nodeId)
        }

        if let node = currentMindMap?.nodes.first(where: { $0.id == nodeId }) {
            node.isExpanded = expandedNodeIds.contains(nodeId)
        }

        markDirty()
    }

    func expandAll() {
        guard let mindMap = currentMindMap else { return }
        for node in mindMap.nodes {
            node.isExpanded = true
            expandedNodeIds.insert(node.id)
        }
        markDirty()
    }

    func collapseAll() {
        guard let mindMap = currentMindMap else { return }
        for node in mindMap.nodes {
            if node.depth > 0 {
                node.isExpanded = false
                expandedNodeIds.remove(node.id)
            }
        }
        markDirty()
    }

    func isNodeExpanded(_ nodeId: UUID) -> Bool {
        expandedNodeIds.contains(nodeId)
    }

    // MARK: - Navigation History

    private func addToNavigationHistory(_ nodeId: UUID) {
        // Remove any forward history
        if historyIndex < navigationHistory.count - 1 {
            navigationHistory = Array(navigationHistory.prefix(historyIndex + 1))
        }

        // Don't add duplicates
        if navigationHistory.last != nodeId {
            navigationHistory.append(nodeId)
            historyIndex = navigationHistory.count - 1
        }
    }

    func navigateBack() -> UUID? {
        guard historyIndex > 0 else { return nil }
        historyIndex -= 1
        let nodeId = navigationHistory[historyIndex]
        selectedNodeId = nodeId
        return nodeId
    }

    func navigateForward() -> UUID? {
        guard historyIndex < navigationHistory.count - 1 else { return nil }
        historyIndex += 1
        let nodeId = navigationHistory[historyIndex]
        selectedNodeId = nodeId
        return nodeId
    }

    private func clearNavigationHistory() {
        navigationHistory = []
        historyIndex = -1
    }

    // MARK: - Canvas Operations

    func zoomIn() {
        canvasZoom = min(canvasZoom * 1.25, maxZoom)
    }

    func zoomOut() {
        canvasZoom = max(canvasZoom / 1.25, minZoom)
    }

    func zoomTo100() {
        canvasZoom = 1.0
    }

    func resetView() {
        canvasZoom = 1.0
        canvasOffset = .zero
    }

    func fitToScreen(viewSize: CGSize) {
        guard let mindMap = currentMindMap, !mindMap.nodes.isEmpty else { return }

        let padding: CGFloat = 50

        var minX = Double.greatestFiniteMagnitude
        var minY = Double.greatestFiniteMagnitude
        var maxX = -Double.greatestFiniteMagnitude
        var maxY = -Double.greatestFiniteMagnitude

        for node in mindMap.nodes {
            minX = min(minX, node.positionX - 60)
            minY = min(minY, node.positionY - 30)
            maxX = max(maxX, node.positionX + 60)
            maxY = max(maxY, node.positionY + 30)
        }

        let contentWidth = maxX - minX + padding * 2
        let contentHeight = maxY - minY + padding * 2

        let scaleX = viewSize.width / contentWidth
        let scaleY = viewSize.height / contentHeight
        canvasZoom = min(min(scaleX, scaleY), maxZoom)

        let centerX = (minX + maxX) / 2
        let centerY = (minY + maxY) / 2

        canvasOffset = CGPoint(
            x: viewSize.width / 2 - centerX * canvasZoom,
            y: viewSize.height / 2 - centerY * canvasZoom
        )
    }

    // MARK: - Auto-Save

    private func startAutoSaveTimer() {
        autoSaveTimer?.invalidate()
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self, self.needsSave else { return }
                self.saveMindMap()
            }
        }
    }

    func markDirty() {
        isDirty = true
        needsSave = true
    }

    // MARK: - Fullscreen

    func toggleFullscreen() {
        isFullscreen.toggle()
    }

    // MARK: - Overlays

    func toggleShortcutsOverlay() {
        isShortcutsOverlayVisible.toggle()
    }

    func toggleSearchOverlay() {
        isSearchOverlayVisible.toggle()
        if !isSearchOverlayVisible {
            searchQuery = ""
        }
    }

    // MARK: - Helper

    func node(withId id: UUID) -> MindMapNode? {
        currentMindMap?.nodes.first { $0.id == id }
    }

    var visibleNodeIds: Set<UUID> {
        guard let mindMap = currentMindMap else { return [] }

        // Start with root if it exists
        var visible: Set<UUID> = []

        func addVisibleNodes(_ node: MindMapNode) {
            visible.insert(node.id)
            if expandedNodeIds.contains(node.id) {
                for child in node.children {
                    addVisibleNodes(child)
                }
            }
        }

        if let root = mindMap.rootNode {
            addVisibleNodes(root)
        }

        return visible
    }
}
