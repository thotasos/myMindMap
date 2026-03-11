import XCTest
@testable import myMindMap

final class NodeConnectionTests: XCTestCase {

    // MARK: - Initialization Tests

    func testConnectionDefaultInitialization() throws {
        let connection = NodeConnection()

        XCTAssertNotNil(connection.id)
        XCTAssertEqual(connection.style, .curved)
        XCTAssertEqual(connection.colorHex, "#888888")
        XCTAssertNotNil(connection.createdAt)
        XCTAssertNil(connection.sourceNode)
        XCTAssertNil(connection.targetNode)
        XCTAssertNil(connection.mindMap)
    }

    func testConnectionWithSourceAndTarget() throws {
        let sourceNode = MindMapNode(text: "Source", positionX: 0, positionY: 0)
        let targetNode = MindMapNode(text: "Target", positionX: 100, positionY: 0)

        let connection = NodeConnection(source: sourceNode, target: targetNode)

        XCTAssertEqual(connection.sourceNode?.id, sourceNode.id)
        XCTAssertEqual(connection.targetNode?.id, targetNode.id)
    }

    func testConnectionWithCustomStyle() throws {
        let connection = NodeConnection(style: .straight)

        XCTAssertEqual(connection.style, .straight)
    }

    func testConnectionWithCustomColor() throws {
        let connection = NodeConnection(colorHex: "#FF5733")

        XCTAssertEqual(connection.colorHex, "#FF5733")
    }

    // MARK: - Style Property Tests

    func testDefaultStyleIsCurved() throws {
        let connection = NodeConnection()

        XCTAssertEqual(connection.style, .curved)
    }

    func testSetStyleToStraight() throws {
        let connection = NodeConnection()
        connection.style = .straight

        XCTAssertEqual(connection.style, .straight)
    }

    func testSetStyleToBezier() throws {
        let connection = NodeConnection()
        connection.style = .bezier

        XCTAssertEqual(connection.style, .bezier)
    }

    func testStyleRawValuePersistence() throws {
        let connection = NodeConnection()
        connection.style = .straight

        XCTAssertEqual(connection.styleRawValue, ConnectionStyle.straight.rawValue)
    }

    // MARK: - ConnectionStyle Enum Tests

    func testConnectionStyleAllCases() throws {
        let allStyles = ConnectionStyle.allCases

        XCTAssertEqual(allStyles.count, 3)
        XCTAssertTrue(allStyles.contains(.straight))
        XCTAssertTrue(allStyles.contains(.curved))
        XCTAssertTrue(allStyles.contains(.bezier))
    }

    func testConnectionStyleDisplayNames() throws {
        XCTAssertEqual(ConnectionStyle.straight.displayName, "Straight")
        XCTAssertEqual(ConnectionStyle.curved.displayName, "Curved")
        XCTAssertEqual(ConnectionStyle.bezier.displayName, "Bezier")
    }

    func testConnectionStyleRawValue() throws {
        XCTAssertEqual(ConnectionStyle.straight.rawValue, "straight")
        XCTAssertEqual(ConnectionStyle.curved.rawValue, "curved")
        XCTAssertEqual(ConnectionStyle.bezier.rawValue, "bezier")
    }

    // MARK: - Color Property Tests

    func testDefaultColor() throws {
        let connection = NodeConnection()

        XCTAssertEqual(connection.colorHex, "#888888")
    }

    func testSetCustomColor() throws {
        let connection = NodeConnection()
        connection.colorHex = "#FF5733"

        XCTAssertEqual(connection.colorHex, "#FF5733")
    }

    // MARK: - MindMap Association Tests

    func testAssociateWithMindMap() throws {
        let mindMap = MindMap(title: "Test Map")
        let connection = NodeConnection()

        connection.mindMap = mindMap

        XCTAssertEqual(connection.mindMap?.id, mindMap.id)
    }
}
