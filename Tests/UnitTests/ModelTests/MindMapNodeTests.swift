import XCTest
@testable import myMindMap

final class MindMapNodeTests: XCTestCase {

    // MARK: - Initialization Tests

    func testNodeDefaultInitialization() throws {
        let node = MindMapNode()

        XCTAssertNotNil(node.id)
        XCTAssertEqual(node.title, "")
        XCTAssertEqual(node.notes, "")
        XCTAssertEqual(node.positionX, 0)
        XCTAssertEqual(node.positionY, 0)
        XCTAssertEqual(node.depth, 0)
        XCTAssertTrue(node.isExpanded)
        XCTAssertNil(node.parentId)
        XCTAssertEqual(node.colorHue, 0.0, accuracy: 0.001)
        XCTAssertEqual(node.colorSaturation, 1.0, accuracy: 0.001)
        XCTAssertEqual(node.colorBrightness, 0.7, accuracy: 0.001)
        XCTAssertTrue(node.children.isEmpty)
    }

    func testNodeCustomInitialization() throws {
        let node = MindMapNode(title: "Custom Node", notes: "Notes", positionX: 50, positionY: 75, depth: 2)

        XCTAssertEqual(node.title, "Custom Node")
        XCTAssertEqual(node.notes, "Notes")
        XCTAssertEqual(node.positionX, 50)
        XCTAssertEqual(node.positionY, 75)
        XCTAssertEqual(node.depth, 2)
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

    // MARK: - Font Size Computed Property Tests

    func testFontSizeDepth0() throws {
        let node = MindMapNode(depth: 0)
        XCTAssertEqual(node.fontSize, 24)
    }

    func testFontSizeDepth1() throws {
        let node = MindMapNode(depth: 1)
        XCTAssertEqual(node.fontSize, 18)
    }

    func testFontSizeDepth2() throws {
        let node = MindMapNode(depth: 2)
        XCTAssertEqual(node.fontSize, 14)
    }

    func testFontSizeDepth3Plus() throws {
        let node = MindMapNode(depth: 5)
        XCTAssertEqual(node.fontSize, 12)
    }

    // MARK: - Frame Property Tests

    func testFrameReturnsCorrectRect() throws {
        let node = MindMapNode(positionX: 100, positionY: 100, depth: 0)

        let frame = node.frame

        XCTAssertEqual(frame.origin.x, 40)  // 100 - 60
        XCTAssertEqual(frame.origin.y, 70)  // 100 - 30
        XCTAssertEqual(frame.width, 120)
        XCTAssertEqual(frame.height, 60)
    }

    func testFrameDepth1Height() throws {
        let node = MindMapNode(positionX: 100, positionY: 100, depth: 1)

        let frame = node.frame

        XCTAssertEqual(frame.height, 40)
    }

    // MARK: - Color Property Tests

    func testDefaultColorHSB() throws {
        let node = MindMapNode()

        XCTAssertEqual(node.colorHue, 0.0, accuracy: 0.001)
        XCTAssertEqual(node.colorSaturation, 1.0, accuracy: 0.001)
        XCTAssertEqual(node.colorBrightness, 0.7, accuracy: 0.001)
    }

    func testColorHexFormat() throws {
        let node = MindMapNode(colorHue: 0.5, colorSaturation: 0.8, colorBrightness: 0.6)

        let hex = node.colorHex

        XCTAssertTrue(hex.hasPrefix("#"))
        XCTAssertTrue(hex.contains("_"))
    }

    func testSetColorFromHex() throws {
        let node = MindMapNode()
        node.colorHex = "#180_80_60"

        XCTAssertEqual(node.colorHue, 0.5, accuracy: 0.01)
        XCTAssertEqual(node.colorSaturation, 0.8, accuracy: 0.01)
        XCTAssertEqual(node.colorBrightness, 0.6, accuracy: 0.01)
    }

    // MARK: - Expand/Collapse State Tests

    func testDefaultExpandedState() throws {
        let node = MindMapNode()

        XCTAssertTrue(node.isExpanded)
    }

    func testToggleExpandedState() throws {
        let node = MindMapNode()

        node.isExpanded = false
        XCTAssertFalse(node.isExpanded)

        node.isExpanded = true
        XCTAssertTrue(node.isExpanded)
    }

    // MARK: - Depth Property Tests

    func testDefaultDepthIsZero() throws {
        let node = MindMapNode()

        XCTAssertEqual(node.depth, 0)
    }

    func testCustomDepth() throws {
        let node = MindMapNode(depth: 3)

        XCTAssertEqual(node.depth, 3)
    }
}
