import XCTest
import SwiftUI
import SwiftData
@testable import myMindMap

@MainActor
final class NodeViewModelTests: XCTestCase {

    var viewModel: NodeViewModel!
    var modelContainer: ModelContainer?
    var modelContext: ModelContext?

    override func setUpWithError() throws {
        viewModel = NodeViewModel()

        let schema = Schema([MindMap.self, MindMapNode.self, MindMapConnection.self, Theme.self])
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
        XCTAssertNil(viewModel.editingNodeId)
        XCTAssertEqual(viewModel.editText, "")
        XCTAssertEqual(viewModel.clipboard, "")
    }

    // MARK: - Node Creation Tests

    func testAddChildNode() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)

        let parentNode = MindMapNode(title: "Parent", positionX: 0, positionY: 0)
        parentNode.mindMap = mindMap
        mindMap.nodes.append(parentNode)

        let childNode = viewModel.addChildNode(to: parentNode, in: mindMap)

        XCTAssertEqual(childNode.parentId, parentNode.id)
        XCTAssertEqual(childNode.title, "New Idea")
        XCTAssertEqual(mindMap.nodes.count, 2)
    }

    func testAddSiblingNode() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)

        let rootNode = MindMapNode(title: "Root", positionX: 0, positionY: 0)
        rootNode.mindMap = mindMap
        mindMap.nodes.append(rootNode)

        let childNode = MindMapNode(title: "Child", positionX: 150, positionY: 0, parentId: rootNode.id)
        childNode.mindMap = mindMap
        rootNode.children.append(childNode)
        mindMap.nodes.append(childNode)

        let siblingNode = viewModel.addSiblingNode(to: childNode, in: mindMap)

        XCTAssertNotNil(siblingNode)
        XCTAssertEqual(siblingNode?.parentId, rootNode.id)
    }

    func testAddSiblingNodeReturnsNilForRoot() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)

        let rootNode = MindMapNode(title: "Root", positionX: 0, positionY: 0)
        rootNode.mindMap = mindMap
        rootNode.parentId = nil
        mindMap.nodes.append(rootNode)

        let siblingNode = viewModel.addSiblingNode(to: rootNode, in: mindMap)

        XCTAssertNil(siblingNode)
    }

    // MARK: - Node Deletion Tests

    func testDeleteNode() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)

        let rootNode = MindMapNode(title: "Root", positionX: 0, positionY: 0)
        rootNode.mindMap = mindMap
        mindMap.nodes.append(rootNode)

        let childNode = MindMapNode(title: "Child", positionX: 150, positionY: 0, parentId: rootNode.id)
        childNode.mindMap = mindMap
        rootNode.children.append(childNode)
        mindMap.nodes.append(childNode)

        let initialCount = mindMap.nodes.count
        viewModel.deleteNode(childNode, in: mindMap)

        XCTAssertEqual(mindMap.nodes.count, initialCount - 1)
    }

    func testCannotDeleteRootNode() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)

        let rootNode = MindMapNode(title: "Root", positionX: 0, positionY: 0)
        rootNode.mindMap = mindMap
        rootNode.parentId = nil
        mindMap.nodes.append(rootNode)

        let initialCount = mindMap.nodes.count
        viewModel.deleteNode(rootNode, in: mindMap)

        // Root node should not be deleted
        XCTAssertEqual(mindMap.nodes.count, initialCount)
    }

    // MARK: - Node Editing Tests

    func testStartEditing() throws {
        let node = MindMapNode(title: "Original Text", positionX: 0, positionY: 0)

        viewModel.startEditing(node)

        XCTAssertEqual(viewModel.editingNodeId, node.id)
        XCTAssertEqual(viewModel.editText, "Original Text")
    }

    func testFinishEditing() throws {
        let node = MindMapNode(title: "Original", positionX: 0, positionY: 0)

        viewModel.startEditing(node)
        viewModel.editText = "Updated Text"
        viewModel.finishEditing(node)

        XCTAssertEqual(node.title, "Updated Text")
        XCTAssertNil(viewModel.editingNodeId)
    }

    func testCancelEditing() throws {
        let node = MindMapNode(title: "Original", positionX: 0, positionY: 0)

        viewModel.startEditing(node)
        viewModel.editText = "Changed"

        viewModel.cancelEditing()

        XCTAssertNil(viewModel.editingNodeId)
        XCTAssertEqual(viewModel.editText, "")
    }

    // MARK: - Node Movement Tests

    func testMoveNode() throws {
        let node = MindMapNode(positionX: 100, positionY: 100)

        viewModel.moveNode(node, by: CGPoint(x: 50, y: 25))

        XCTAssertEqual(node.positionX, 150)
        XCTAssertEqual(node.positionY, 125)
    }

    func testMoveNodeTo() throws {
        let node = MindMapNode(positionX: 100, positionY: 100)

        viewModel.moveNodeTo(node, position: CGPoint(x: 200, y: 200))

        XCTAssertEqual(node.positionX, 200)
        XCTAssertEqual(node.positionY, 200)
    }

    // MARK: - Expand/Collapse Tests

    func testToggleCollapse() throws {
        let node = MindMapNode()

        XCTAssertTrue(node.isExpanded)

        node.isExpanded.toggle()

        XCTAssertFalse(node.isExpanded)

        node.isExpanded.toggle()

        XCTAssertTrue(node.isExpanded)
    }

    // MARK: - Clipboard Tests

    func testClipboard() throws {
        viewModel.clipboard = "Test content"

        XCTAssertEqual(viewModel.clipboard, "Test content")
    }
}
