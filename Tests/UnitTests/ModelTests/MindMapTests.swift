import XCTest
@testable import myMindMap

final class MindMapTests: XCTestCase {

    override func setUpWithError() throws {
        // Setup code before each test
    }

    override func tearDownWithError() throws {
        // Teardown code after each test
    }

    // MARK: - Initialization Tests

    func testMindMapDefaultInitialization() throws {
        let mindMap = MindMap()

        XCTAssertNotNil(mindMap.id)
        XCTAssertEqual(mindMap.title, "Untitled Mind Map")
        XCTAssertNotNil(mindMap.createdAt)
        XCTAssertNotNil(mindMap.modifiedAt)
        XCTAssertTrue(mindMap.nodes.isEmpty)
        XCTAssertTrue(mindMap.connections.isEmpty)
        XCTAssertNil(mindMap.theme)
    }

    func testMindMapCustomTitleInitialization() throws {
        let mindMap = MindMap(title: "My Custom Map")

        XCTAssertEqual(mindMap.title, "My Custom Map")
    }

    // MARK: - Root Node Tests

    func testRootNodeReturnsNilWhenNoNodes() throws {
        let mindMap = MindMap()

        XCTAssertNil(mindMap.rootNode)
    }

    func testRootNodeReturnsNodeWithNoParent() throws {
        let mindMap = MindMap()
        let rootNode = MindMapNode(text: "Root", positionX: 0, positionY: 0)
        mindMap.nodes.append(rootNode)

        XCTAssertEqual(mindMap.rootNode?.id, rootNode.id)
    }

    func testRootNodeReturnsFirstNodeWithNoParent() throws {
        let mindMap = MindMap()
        let firstRoot = MindMapNode(text: "First Root", positionX: 0, positionY: 0)
        let secondNode = MindMapNode(text: "Second", positionX: 100, positionY: 100)
        secondNode.parent = firstRoot
        mindMap.nodes.append(firstRoot)
        mindMap.nodes.append(secondNode)

        XCTAssertEqual(mindMap.rootNode?.id, firstRoot.id)
    }

    // MARK: - Modified Date Tests

    func testMarkModifiedUpdatesModifiedAt() throws {
        let mindMap = MindMap()
        let originalModifiedAt = mindMap.modifiedAt

        // Small delay to ensure different timestamp
        Thread.sleep(forTimeInterval: 0.01)

        mindMap.markModified()

        XCTAssertGreaterThan(mindMap.modifiedAt, originalModifiedAt)
    }

    // MARK: - Node Management Tests

    func testAddNodeToMindMap() throws {
        let mindMap = MindMap()
        let node = MindMapNode(text: "Test Node", positionX: 100, positionY: 100)

        mindMap.nodes.append(node)

        XCTAssertEqual(mindMap.nodes.count, 1)
        XCTAssertEqual(mindMap.nodes.first?.text, "Test Node")
    }

    func testAddMultipleNodes() throws {
        let mindMap = MindMap()

        let node1 = MindMapNode(text: "Node 1", positionX: 0, positionY: 0)
        let node2 = MindMapNode(text: "Node 2", positionX: 100, positionY: 0)
        let node3 = MindMapNode(text: "Node 3", positionX: 200, positionY: 0)

        mindMap.nodes.append(contentsOf: [node1, node2, node3])

        XCTAssertEqual(mindMap.nodes.count, 3)
    }

    // MARK: - Connection Management Tests

    func testAddConnectionToMindMap() throws {
        let mindMap = MindMap()
        let sourceNode = MindMapNode(text: "Source", positionX: 0, positionY: 0)
        let targetNode = MindMapNode(text: "Target", positionX: 100, positionY: 0)

        let connection = NodeConnection(source: sourceNode, target: targetNode)

        mindMap.nodes.append(contentsOf: [sourceNode, targetNode])
        mindMap.connections.append(connection)

        XCTAssertEqual(mindMap.connections.count, 1)
        XCTAssertEqual(mindMap.connections.first?.sourceNode?.id, sourceNode.id)
    }
}
