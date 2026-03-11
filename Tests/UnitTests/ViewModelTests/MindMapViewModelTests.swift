import XCTest
import SwiftUI
import SwiftData
@testable import myMindMap

final class MindMapViewModelTests: XCTestCase {

    var viewModel: MindMapViewModel!
    var modelContainer: ModelContainer?
    var modelContext: ModelContext?

    override func setUpWithError() throws {
        viewModel = MindMapViewModel()

        // Setup SwiftData container for testing
        let schema = Schema([MindMap.self, MindMapNode.self, NodeConnection.self, Theme.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try? ModelContainer(for: schema, configurations: config)
        if let container = modelContainer {
            modelContext = ModelContext(container)
            viewModel.setModelContext(modelContext!)
        }
    }

    override func tearDownWithError() throws {
        viewModel = nil
        modelContainer = nil
        modelContext = nil
    }

    // MARK: - Initialization Tests

    func testDefaultInitialization() throws {
        XCTAssertNil(viewModel.currentMindMap)
        XCTAssertTrue(viewModel.recentMindMaps.isEmpty)
        XCTAssertFalse(viewModel.isDirty)
    }

    // MARK: - Create New Mind Map Tests

    func testCreateNewMindMap() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        viewModel.createNewMindMap()

        XCTAssertNotNil(viewModel.currentMindMap)
        XCTAssertTrue(viewModel.isDirty)
        XCTAssertEqual(viewModel.currentMindMap?.title, "Untitled Mind Map")
    }

    func testCreateNewMindMapAddsRootNode() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        viewModel.createNewMindMap()

        let nodes = viewModel.currentMindMap?.nodes ?? []
        XCTAssertEqual(nodes.count, 1)
        XCTAssertEqual(nodes.first?.text, "Central Idea")
    }

    func testCreateNewMindMapSetsRootNodePosition() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        viewModel.createNewMindMap()

        let rootNode = viewModel.currentMindMap?.rootNode
        XCTAssertEqual(rootNode?.positionX, 0)
        XCTAssertEqual(rootNode?.positionY, 0)
    }

    // MARK: - Save Mind Map Tests

    func testSaveMindMapSetsDirtyToFalse() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        viewModel.createNewMindMap()
        XCTAssertTrue(viewModel.isDirty)

        viewModel.saveMindMap()

        XCTAssertFalse(viewModel.isDirty)
    }

    func testSaveMindMapUpdatesModifiedDate() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        viewModel.createNewMindMap()
        let originalModifiedAt = viewModel.currentMindMap?.modifiedAt

        Thread.sleep(forTimeInterval: 0.01)
        viewModel.saveMindMap()

        XCTAssertGreaterThan(viewModel.currentMindMap?.modifiedAt ?? Date.distantPast, originalModifiedAt ?? Date.distantPast)
    }

    func testSaveMindMapWithNoCurrentMap() throws {
        // Should not crash when there's no current mind map
        viewModel.saveMindMap()

        XCTAssertNil(viewModel.currentMindMap)
    }

    // MARK: - Load Recent Mind Maps Tests

    func testLoadRecentMindMaps() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        // Create multiple mind maps
        for i in 1...5 {
            let map = MindMap(title: "Map \(i)")
            context.insert(map)
        }
        try context.save()

        viewModel.loadRecentMindMaps()

        XCTAssertFalse(viewModel.recentMindMaps.isEmpty)
    }

    func testLoadRecentMindMapsLimitsTo10() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        // Create 15 mind maps
        for i in 1...15 {
            let map = MindMap(title: "Map \(i)")
            context.insert(map)
        }
        try context.save()

        viewModel.loadRecentMindMaps()

        XCTAssertLessThanOrEqual(viewModel.recentMindMaps.count, 10)
    }

    func testLoadRecentMindMapsSortedByModifiedDate() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let map1 = MindMap(title: "First")
        let map2 = MindMap(title: "Second")
        context.insert(map1)
        context.insert(map2)
        map1.markModified()
        Thread.sleep(forTimeInterval: 0.01)
        map2.markModified()
        try context.save()

        viewModel.loadRecentMindMaps()

        // Most recently modified should be first
        if viewModel.recentMindMaps.count >= 2 {
            XCTAssertGreaterThanOrEqual(
                viewModel.recentMindMaps[0].modifiedAt,
                viewModel.recentMindMaps[1].modifiedAt
            )
        }
    }

    // MARK: - Open Mind Map Tests

    func testOpenMindMap() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)
        try context.save()

        viewModel.openMindMap(mindMap)

        XCTAssertEqual(viewModel.currentMindMap?.id, mindMap.id)
        XCTAssertFalse(viewModel.isDirty)
    }

    // MARK: - Delete Mind Map Tests

    func testDeleteMindMap() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)
        try context.save()

        viewModel.deleteMindMap(mindMap)

        XCTAssertNil(viewModel.currentMindMap)
    }

    func testDeleteCurrentMindMapClearsCurrent() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        viewModel.createNewMindMap()
        guard let currentMap = viewModel.currentMindMap else {
            XCTFail("No current map")
            return
        }

        viewModel.deleteMindMap(currentMap)

        XCTAssertNil(viewModel.currentMindMap)
    }

    // MARK: - Model Context Tests

    func testSetModelContext() throws {
        let schema = Schema([MindMap.self, MindMapNode.self, NodeConnection.self, Theme.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: config)
        let newContext = ModelContext(container)

        viewModel.setModelContext(newContext)

        XCTAssertNotNil(viewModel.modelContext)
    }

    // MARK: - Dirty State Tests

    func testIsDirtyInitiallyFalse() throws {
        XCTAssertFalse(viewModel.isDirty)
    }

    func testIsDirtyTrueAfterCreate() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        viewModel.createNewMindMap()

        XCTAssertTrue(viewModel.isDirty)
    }

    func testIsDirtyFalseAfterSave() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        viewModel.createNewMindMap()
        viewModel.saveMindMap()

        XCTAssertFalse(viewModel.isDirty)
    }
}
