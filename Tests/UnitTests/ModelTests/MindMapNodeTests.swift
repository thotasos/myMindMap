import XCTest
@testable import myMindMap

final class MindMapNodeTests: XCTestCase {

    // MARK: - Initialization Tests

    func testNodeDefaultInitialization() throws {
        let node = MindMapNode()

        XCTAssertNotNil(node.id)
        XCTAssertEqual(node.text, "New Node")
        XCTAssertEqual(node.positionX, 0)
        XCTAssertEqual(node.positionY, 0)
        XCTAssertEqual(node.width, 120)
        XCTAssertEqual(node.height, 40)
        XCTAssertEqual(node.backgroundColorHex, "#FFFFFF")
        XCTAssertEqual(node.textColorHex, "#000000")
        XCTAssertEqual(node.fontSize, 14)
        XCTAssertFalse(node.isCollapsed)
        XCTAssertNotNil(node.createdAt)
        XCTAssertTrue(node.children.isEmpty)
        XCTAssertTrue(node.outgoingConnections.isEmpty)
        XCTAssertTrue(node.incomingConnections.isEmpty)
    }

    func testNodeCustomInitialization() throws {
        let node = MindMapNode(text: "Custom Node", positionX: 50, positionY: 75)

        XCTAssertEqual(node.text, "Custom Node")
        XCTAssertEqual(node.positionX, 50)
        XCTAssertEqual(node.positionY, 75)
    }

    // MARK: - Position Property Tests

    func testPositionGetterReturnsCGPoint() throws {
        let node = MindMapNode(positionX: 100, positionY: 200)

        let position = node.position

        XCTAssertEqual(position.x, 100)
        XCTAssertEqual(position.y, 200)
    }

    func testPositionSetterUpdatesCoordinates() throws {
        let node = MindMapNode()

        node.position = CGPoint(x: 150, y: 250)

        XCTAssertEqual(node.positionX, 150)
        XCTAssertEqual(node.positionY, 250)
    }

    // MARK: - Frame Property Tests

    func testFrameReturnsCorrectRect() throws {
        let node = MindMapNode(positionX: 100, positionY: 100)
        node.width = 120
        node.height = 40

        let frame = node.frame

        XCTAssertEqual(frame.origin.x, 40)  // 100 - 60
        XCTAssertEqual(frame.origin.y, 80)   // 100 - 20
        XCTAssertEqual(frame.width, 120)
        XCTAssertEqual(frame.height, 40)
    }

    func testFrameCenterMatchesPosition() throws {
        let node = MindMapNode(positionX: 100, positionY: 200)
        node.width = 100
        node.height = 50

        let frame = node.frame

        XCTAssertEqual(frame.midX, 100)
        XCTAssertEqual(frame.midY, 200)
    }

    // MARK: - Node Hierarchy Tests

    func testAddChildNode() throws {
        let parent = MindMapNode(text: "Parent", positionX: 0, positionY: 0)
        let child = MindMapNode(text: "Child", positionX: 100, positionY: 0)

        child.parent = parent
        parent.children.append(child)

        XCTAssertEqual(parent.children.count, 1)
        XCTAssertEqual(child.parent?.id, parent.id)
    }

    func testMultipleChildren() throws {
        let parent = MindMapNode(text: "Parent", positionX: 0, positionY: 0)

        let child1 = MindMapNode(text: "Child 1", positionX: 100, positionY: 0)
        let child2 = MindMapNode(text: "Child 2", positionX: 100, positionY: 50)
        let child3 = MindMapNode(text: "Child 3", positionX: 100, positionY: 100)

        child1.parent = parent
        child2.parent = parent
        child3.parent = parent

        parent.children.append(contentsOf: [child1, child2, child3])

        XCTAssertEqual(parent.children.count, 3)
    }

    func testNestedChildren() throws {
        let grandparent = MindMapNode(text: "Grandparent", positionX: 0, positionY: 0)
        let parent = MindMapNode(text: "Parent", positionX: 100, positionY: 0)
        let child = MindMapNode(text: "Child", positionX: 200, positionY: 0)

        parent.parent = grandparent
        child.parent = parent

        grandparent.children.append(parent)
        parent.children.append(child)

        XCTAssertEqual(grandparent.children.count, 1)
        XCTAssertEqual(parent.children.count, 1)
        XCTAssertEqual(child.parent?.parent?.id, grandparent.id)
    }

    // MARK: - Color Property Tests

    func testDefaultColors() throws {
        let node = MindMapNode()

        XCTAssertEqual(node.backgroundColorHex, "#FFFFFF")
        XCTAssertEqual(node.textColorHex, "#000000")
    }

    func testCustomColors() throws {
        let node = MindMapNode()
        node.backgroundColorHex = "#FF5733"
        node.textColorHex = "#C70039"

        XCTAssertEqual(node.backgroundColorHex, "#FF5733")
        XCTAssertEqual(node.textColorHex, "#C70039")
    }

    // MARK: - Collapsed State Tests

    func testDefaultCollapsedState() throws {
        let node = MindMapNode()

        XCTAssertFalse(node.isCollapsed)
    }

    func testToggleCollapsedState() throws {
        let node = MindMapNode()

        node.isCollapsed = true
        XCTAssertTrue(node.isCollapsed)

        node.isCollapsed = false
        XCTAssertFalse(node.isCollapsed)
    }

    // MARK: - Font Size Tests

    func testDefaultFontSize() throws {
        let node = MindMapNode()

        XCTAssertEqual(node.fontSize, 14)
    }

    func testCustomFontSize() throws {
        let node = MindMapNode()
        node.fontSize = 18

        XCTAssertEqual(node.fontSize, 18)
    }
}
