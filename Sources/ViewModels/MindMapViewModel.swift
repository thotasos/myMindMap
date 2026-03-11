import Foundation
import SwiftUI
import SwiftData
import AppKit

@Observable
class MindMapViewModel {
    var currentMindMap: MindMap?
    var recentMindMaps: [MindMap] = []
    var isDirty: Bool = false

    var modelContext: ModelContext?

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    func createNewMindMap() {
        let mindMap = MindMap(title: "Untitled Mind Map")

        // Create root node at center
        let rootNode = MindMapNode(text: "Central Idea", positionX: 0, positionY: 0)
        mindMap.nodes.append(rootNode)

        currentMindMap = mindMap
        isDirty = true

        guard let context = modelContext else { return }
        context.insert(mindMap)

        try? context.save()
    }

    func saveMindMap() {
        guard let mindMap = currentMindMap else { return }
        mindMap.markModified()

        guard let context = modelContext else { return }
        try? context.save()

        isDirty = false
    }

    func loadRecentMindMaps() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<MindMap>(
            sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
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
}
