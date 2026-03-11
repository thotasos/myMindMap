import XCTest
import SwiftUI
import SwiftData
@testable import myMindMap

final class NodeViewModelTests: XCTestCase {

    var viewModel: NodeViewModel!
    var modelContainer: ModelContainer?
    var modelContext: ModelContext?

    override func setUpWithError() throws {
        viewModel = NodeViewModel()

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
        XCTAssertNil(viewModel.editingNodeID)
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

        let parentNode = MindMapNode(text: "Parent", positionX: 0, positionY: 0)
        parentNode.mindMap = mindMap
        mindMap.nodes.append(parentNode)

        let childNode = viewModel.addChildNode(to: parentNode, in: mindMap)

        XCTAssertEqual(parentNode.children.count, 1)
        XCTAssertEqual(childNode.parent?.id, parentNode.id)
        XCTAssertEqual(childNode.text, "New Idea")
    }

    func testAddSiblingNode() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)

        let rootNode = MindMapNode(text: "Root", positionX: 0, positionY: 0)
        rootNode.mindMap = mindMap
        mindMap.nodes.append(rootNode)

        let childNode = MindMapNode(text: "Child", positionX: 150, positionY: 0)
        childNode.parent = rootNode
        childNode.mindMap = mindMap
        rootNode.children.append(childNode)
        mindMap.nodes.append(childNode)

        let siblingNode = viewModel.addSiblingNode(to: childNode, in: mindMap)

        XCTAssertNotNil(siblingNode)
        XCTAssertEqual(siblingNode?.parent?.id, rootNode.id)
    }

    func testAddSiblingNodeReturnsNilForRoot() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)

        let rootNode = MindMapNode(text: "Root", positionX: 0, positionY: 0)
        rootNode.mindMap = mindMap
        rootNode.parent = nil
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

        let rootNode = MindMapNode(text: "Root", positionX: 0, positionY: 0)
        rootNode.mindMap = mindMap
        mindMap.nodes.append(rootNode)

        let childNode = MindMapNode(text: "Child", positionX: 150, positionY: 0)
        childNode.parent = rootNode
        childNode.mindMap = mindMap
        rootNode.children.append(childNode)
        mindMap.nodes.append(childNode)

        let initialCount = mindMap.nodes.count
        viewModel.deleteNode(childNode, in: mindMap)

        XCTAssertEqual(mindMap.nodes.count, initialCount - 1)
    }

    func testDeleteNodeWithChildren() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)

        let rootNode = MindMapNode(text: "Root", positionX: 0, positionY: 0)
        rootNode.mindMap = mindMap
        mindMap.nodes.append(rootNode)

        let parent = MindMapNode(text: "Parent", positionX: 150, positionY: 0)
        parent.parent = rootNode
        parent.mindMap = mindMap
        rootNode.children.append(parent)
        mindMap.nodes.append(parent)

        let child = MindMapNode(text: "Child", positionX: 300, positionY: 0)
        child.parent = parent
        child.mindMap = mindMap
        parent.children.append(child)
        mindMap.nodes.append(child)

        let initialCount = mindMap.nodes.count
        viewModel.deleteNode(parent, in: mindMap)

        // Should delete both parent and child
        XCTAssertEqual(mindMap.nodes.count, initialCount - 2)
    }

    func testCannotDeleteRootNode() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)

        let rootNode = MindMapNode(text: "Root", positionX: 0, positionY: 0)
        rootNode.mindMap = mindMap
        rootNode.parent = nil
        mindMap.nodes.append(rootNode)

        let initialCount = mindMap.nodes.count
        viewModel.deleteNode(rootNode, in: mindMap)

        // Root node should not be deleted
        XCTAssertEqual(mindMap.nodes.count, initialCount)
    }

    // MARK: - Node Editing Tests

    func testStartEditing() throws {
        let node = MindMapNode(text: "Original Text", positionX: 0, positionY: 0)

        viewModel.startEditing(node)

        XCTAssertEqual(viewModel.editingNodeID, node.id)
        XCTAssertEqual(viewModel.editText, "Original Text")
    }

    func testFinishEditing() throws {
        let node = MindMapNode(text: "Original", positionX: 0, positionY: 0)

        viewModel.startEditing(node)
        viewModel.editText = "Updated Text"
        viewModel.finishEditing(node)

        XCTAssertEqual(node.text, "Updated Text")
        XCTAssertNil(viewModel.editingNodeID)
    }

    func testCancelEditing() throws {
        let node = MindMapNode(text: "Original", positionX: 0, positionY: 0)

        viewModel.startEditing(node)
        viewModel.editText = "Changed"

        viewModel.cancelEditing()

        XCTAssertNil(viewModel.editingNodeID)
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

    // MARK: - Collapse/Expand Tests

    func testToggleCollapse() throws {
        let node = MindMapNode()

        XCTAssertFalse(node.isCollapsed)

        viewModel.toggleCollapse(node)

        XCTAssertTrue(node.isCollapsed)

        viewModel.toggleCollapse(node)

        XCTAssertFalse(node.isCollapsed)
    }

    // MARK: - Node Duplication Tests

    func testDuplicateNode() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)

        let rootNode = MindMapNode(text: "Root", positionX: 0, positionY: 0)
        rootNode.mindMap = mindMap
        mindMap.nodes.append(rootNode)

        let nodeToDuplicate = MindMapNode(text: "Original", positionX: 150, positionY: 0)
        nodeToDuplicate.parent = rootNode
        nodeToDuplicate.mindMap = mindMap
        rootNode.children.append(nodeToDuplicate)
        mindMap.nodes.append(nodeToDuplicate)

        let duplicate = viewModel.duplicateNode(nodeToDuplicate, in: mindMap)

        XCTAssertNotNil(duplicate)
        XCTAssertEqual(duplicate?.text, "Original (copy)")
        XCTAssertEqual(duplicate?.parent?.id, rootNode.id)
    }

    func testDuplicateNodeReturnsNilForRoot() throws {
        guard let context = modelContext else {
            XCTSkip("ModelContext not available")
            return
        }

        let mindMap = MindMap(title: "Test Map")
        context.insert(mindMap)

        let rootNode = MindMapNode(text: "Root", positionX: 0, positionY: 0)
        rootNode.mindMap = mindMap
        rootNode.parent = nil
        mindMap.nodes.append(rootNode)

        let duplicate = viewModel.duplicateNode(rootNode, in: mindMap)

        XCTAssertNil(duplicate)
    }

    // MARK: - Clipboard Tests

    func testClipboard() throws {
        viewModel.clipboard = "Test content"

        XCTAssertEqual(viewModel.clipboard, "Test content")
    }
}
