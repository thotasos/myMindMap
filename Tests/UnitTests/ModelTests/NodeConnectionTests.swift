import XCTest
@testable import myMindMap

final class NodeConnectionTests: XCTestCase {

    // MARK: - Initialization Tests

    func testConnectionDefaultInitialization() throws {
        let sourceNode = MindMapNode(title: "Source", positionX: 0, positionY: 0)
        let targetNode = MindMapNode(title: "Target", positionX: 100, positionY: 0)
        let connection = MindMapConnection(sourceNodeId: sourceNode.id, targetNodeId: targetNode.id)

        XCTAssertNotNil(connection.id)
        XCTAssertEqual(connection.sourceNodeId, sourceNode.id)
        XCTAssertEqual(connection.targetNodeId, targetNode.id)
        XCTAssertEqual(connection.colorHue, 0.0, accuracy: 0.001)
        XCTAssertEqual(connection.colorSaturation, 1.0, accuracy: 0.001)
        XCTAssertEqual(connection.colorBrightness, 0.7, accuracy: 0.001)
    }

    func testConnectionWithCustomColor() throws {
        let sourceNode = MindMapNode(title: "Source", positionX: 0, positionY: 0)
        let targetNode = MindMapNode(title: "Target", positionX: 100, positionY: 0)

        let connection = MindMapConnection(
            sourceNodeId: sourceNode.id,
            targetNodeId: targetNode.id,
            colorHue: 0.5,
            colorSaturation: 0.8,
            colorBrightness: 0.6
        )

        XCTAssertEqual(connection.colorHue, 0.5, accuracy: 0.001)
        XCTAssertEqual(connection.colorSaturation, 0.8, accuracy: 0.001)
        XCTAssertEqual(connection.colorBrightness, 0.6, accuracy: 0.001)
    }

    // MARK: - Color Property Tests

    func testDefaultColorHSB() throws {
        let sourceNode = MindMapNode(title: "Source", positionX: 0, positionY: 0)
        let targetNode = MindMapNode(title: "Target", positionX: 100, positionY: 0)
        let connection = MindMapConnection(sourceNodeId: sourceNode.id, targetNodeId: targetNode.id)

        XCTAssertEqual(connection.colorHue, 0.0)
        XCTAssertEqual(connection.colorSaturation, 1.0)
        XCTAssertEqual(connection.colorBrightness, 0.7)
    }

    func testColorHexFormat() throws {
        let sourceNode = MindMapNode(title: "Source", positionX: 0, positionY: 0)
        let targetNode = MindMapNode(title: "Target", positionX: 100, positionY: 0)
        let connection = MindMapConnection(
            sourceNodeId: sourceNode.id,
            targetNodeId: targetNode.id,
            colorHue: 0.25,
            colorSaturation: 0.9,
            colorBrightness: 0.5
        )

        let hex = connection.colorHex

        XCTAssertTrue(hex.hasPrefix("#"))
        XCTAssertTrue(hex.contains("_"))
    }

    // MARK: - MindMap Association Tests

    func testAssociateWithMindMap() throws {
        let mindMap = MindMap(title: "Test Map")
        let sourceNode = MindMapNode(title: "Source", positionX: 0, positionY: 0)
        let targetNode = MindMapNode(title: "Target", positionX: 100, positionY: 0)

        mindMap.nodes.append(contentsOf: [sourceNode, targetNode])

        let connection = MindMapConnection(sourceNodeId: sourceNode.id, targetNodeId: targetNode.id, mindMap: mindMap)
        mindMap.connections.append(connection)

        XCTAssertEqual(connection.mindMap?.id, mindMap.id)
    }

    // MARK: - Node ID Reference Tests

    func testConnectionReferencesNodeIds() throws {
        let sourceNode = MindMapNode(title: "Source", positionX: 0, positionY: 0)
        let targetNode = MindMapNode(title: "Target", positionX: 100, positionY: 0)

        let sourceId = sourceNode.id
        let targetId = targetNode.id

        let connection = MindMapConnection(sourceNodeId: sourceId, targetNodeId: targetId)

        XCTAssertEqual(connection.sourceNodeId, sourceId)
        XCTAssertEqual(connection.targetNodeId, targetId)
        XCTAssertNotEqual(connection.sourceNodeId, connection.targetNodeId)
    }
}
