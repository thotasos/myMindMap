import Foundation
import SwiftData

/// Protocol for mind map data access
protocol MindMapRepository: AnyObject {
    @MainActor func save(_ mindMap: MindMap) async throws
    @MainActor func load(id: UUID) async throws -> MindMap?
    @MainActor func queryViewport(_ rect: CGRect, in mindMap: MindMap) async throws -> [MindMapNode]
    @MainActor func delete(_ mindMap: MindMap) async throws
    @MainActor func fetchAll() async throws -> [MindMap]
}

/// SwiftData implementation of MindMapRepository
@MainActor
final class SwiftDataMindMapRepository: MindMapRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(_ mindMap: MindMap) async throws {
        modelContext.insert(mindMap)
        try modelContext.save()
    }

    func load(id: UUID) async throws -> MindMap? {
        let descriptor = FetchDescriptor<MindMap>(
            predicate: #Predicate { $0.id == id }
        )
        return try modelContext.fetch(descriptor).first
    }

    func queryViewport(_ rect: CGRect, in mindMap: MindMap) async throws -> [MindMapNode] {
        // Simple viewport query - filter nodes that intersect with rect
        mindMap.nodes.filter { node in
            rect.intersects(node.frame)
        }
    }

    func delete(_ mindMap: MindMap) async throws {
        modelContext.delete(mindMap)
        try modelContext.save()
    }

    func fetchAll() async throws -> [MindMap] {
        let descriptor = FetchDescriptor<MindMap>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
}
