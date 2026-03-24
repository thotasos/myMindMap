import XCTest
@testable import myMindMap

final class MindMapTests: XCTestCase {

    // MARK: - Initialization Tests

    func testMindMapDefaultInitialization() throws {
        let mindMap = MindMap()

        XCTAssertNotNil(mindMap.id)
        XCTAssertEqual(mindMap.title, "Untitled")
        XCTAssertNotNil(mindMap.createdAt)
        XCTAssertNotNil(mindMap.updatedAt)
        XCTAssertTrue(mindMap.nodes.isEmpty)
        XCTAssertTrue(mindMap.connections.isEmpty)
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
        let rootNode = MindMapNode(title: "Root", positionX: 0, positionY: 0)
        mindMap.nodes.append(rootNode)

        XCTAssertEqual(mindMap.rootNode?.id, rootNode.id)
    }

    func testRootNodeReturnsFirstNodeWithNoParent() throws {
        let mindMap = MindMap()
        let firstRoot = MindMapNode(title: "First Root", positionX: 0, positionY: 0)
        let secondNode = MindMapNode(title: "Second", positionX: 100, positionY: 100)
        secondNode.parentId = firstRoot.id
        mindMap.nodes.append(firstRoot)
        mindMap.nodes.append(secondNode)

        XCTAssertEqual(mindMap.rootNode?.id, firstRoot.id)
    }

    // MARK: - Modified Date Tests

    func testMarkModifiedUpdatesModifiedAt() throws {
        let mindMap = MindMap()
        let originalModifiedAt = mindMap.updatedAt

        Thread.sleep(forTimeInterval: 0.01)
        mindMap.markModified()

        XCTAssertGreaterThan(mindMap.updatedAt, originalModifiedAt)
    }

    // MARK: - Node Management Tests

    func testAddNodeToMindMap() throws {
        let mindMap = MindMap()
        let node = MindMapNode(title: "Test Node", positionX: 100, positionY: 100)

        mindMap.nodes.append(node)

        XCTAssertEqual(mindMap.nodes.count, 1)
        XCTAssertEqual(mindMap.nodes.first?.title, "Test Node")
    }

    func testAddMultipleNodes() throws {
        let mindMap = MindMap()

        let node1 = MindMapNode(title: "Node 1", positionX: 0, positionY: 0)
        let node2 = MindMapNode(title: "Node 2", positionX: 100, positionY: 0)
        let node3 = MindMapNode(title: "Node 3", positionX: 200, positionY: 0)

        mindMap.nodes.append(contentsOf: [node1, node2, node3])

        XCTAssertEqual(mindMap.nodes.count, 3)
    }

    // MARK: - Connection Management Tests

    func testAddConnectionToMindMap() throws {
        let mindMap = MindMap()
        let sourceNode = MindMapNode(title: "Source", positionX: 0, positionY: 0)
        let targetNode = MindMapNode(title: "Target", positionX: 100, positionY: 0)

        mindMap.nodes.append(contentsOf: [sourceNode, targetNode])

        let connection = MindMapConnection(sourceNodeId: sourceNode.id, targetNodeId: targetNode.id)
        mindMap.connections.append(connection)

        XCTAssertEqual(mindMap.connections.count, 1)
        XCTAssertEqual(mindMap.connections.first?.sourceNodeId, sourceNode.id)
        XCTAssertEqual(mindMap.connections.first?.targetNodeId, targetNode.id)
    }

    func testConnectionDefaultColor() throws {
        let sourceNode = MindMapNode(title: "Source", positionX: 0, positionY: 0)
        let targetNode = MindMapNode(title: "Target", positionX: 100, positionY: 0)
        let connection = MindMapConnection(sourceNodeId: sourceNode.id, targetNodeId: targetNode.id)

        XCTAssertEqual(connection.colorHue, 0.0, accuracy: 0.001)
        XCTAssertEqual(connection.colorSaturation, 1.0, accuracy: 0.001)
        XCTAssertEqual(connection.colorBrightness, 0.7, accuracy: 0.001)
    }
}
