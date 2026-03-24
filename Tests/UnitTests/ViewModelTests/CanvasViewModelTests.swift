import XCTest
import SwiftUI
@testable import myMindMap

@MainActor
final class CanvasViewModelTests: XCTestCase {

    var viewModel: CanvasViewModel!

    override func setUpWithError() throws {
        viewModel = CanvasViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    // MARK: - Initialization Tests

    func testDefaultInitialization() throws {
        XCTAssertEqual(viewModel.scale, 1.0)
        XCTAssertEqual(viewModel.offset, .zero)
        XCTAssertEqual(viewModel.canvasSize, .zero)
        XCTAssertTrue(viewModel.selectedNodeIDs.isEmpty)
        XCTAssertNil(viewModel.focusedNodeID)
        XCTAssertTrue(viewModel.showGrid)
        XCTAssertEqual(viewModel.gridSpacing, 20)
    }

    // MARK: - Zoom Tests

    func testZoomInIncreasesScale() throws {
        let initialScale = viewModel.scale

        viewModel.zoomIn()

        XCTAssertGreaterThan(viewModel.scale, initialScale)
    }

    func testZoomInRespectsMaxScale() throws {
        viewModel.scale = 2.5

        viewModel.zoomIn()

        XCTAssertLessThanOrEqual(viewModel.scale, viewModel.maxScale)
    }

    func testZoomOutDecreasesScale() throws {
        viewModel.scale = 1.0

        viewModel.zoomOut()

        XCTAssertLessThan(viewModel.scale, 1.0)
    }

    func testZoomOutRespectsMinScale() throws {
        viewModel.scale = 0.15

        viewModel.zoomOut()

        XCTAssertGreaterThanOrEqual(viewModel.scale, viewModel.minScale)
    }

    // MARK: - Pan Tests

    func testPanUpdatesOffset() throws {
        let initialOffset = viewModel.offset

        viewModel.pan(by: CGPoint(x: 50, y: 100))

        XCTAssertEqual(viewModel.offset.x, initialOffset.x + 50)
        XCTAssertEqual(viewModel.offset.y, initialOffset.y + 100)
    }

    func testPanWithNegativeDelta() throws {
        viewModel.offset = CGPoint(x: 100, y: 100)

        viewModel.pan(by: CGPoint(x: -50, y: -50))

        XCTAssertEqual(viewModel.offset.x, 50)
        XCTAssertEqual(viewModel.offset.y, 50)
    }

    // MARK: - Reset View Tests

    func testResetViewResetsScaleAndOffset() throws {
        viewModel.scale = 2.0
        viewModel.offset = CGPoint(x: 100, y: 100)

        viewModel.resetView()

        XCTAssertEqual(viewModel.scale, 1.0)
        XCTAssertEqual(viewModel.offset, .zero)
    }

    // MARK: - Fit to Screen Tests

    func testFitToScreenWithEmptyNodes() throws {
        viewModel.fitToScreen(nodes: [], viewSize: CGSize(width: 800, height: 600))

        // Should not crash with empty nodes
        XCTAssertTrue(true)
    }

    func testFitToScreenWithSingleNode() throws {
        let node = MindMapNode(title: "Root", positionX: 0, positionY: 0)

        viewModel.fitToScreen(nodes: [node], viewSize: CGSize(width: 800, height: 600))

        XCTAssertGreaterThan(viewModel.scale, 0)
    }

    func testFitToScreenWithMultipleNodes() throws {
        let nodes = [
            MindMapNode(title: "Node1", positionX: 0, positionY: 0),
            MindMapNode(title: "Node2", positionX: 200, positionY: 100),
            MindMapNode(title: "Node3", positionX: 400, positionY: 200)
        ]

        viewModel.fitToScreen(nodes: nodes, viewSize: CGSize(width: 800, height: 600))

        XCTAssertGreaterThan(viewModel.scale, 0)
        XCTAssertLessThanOrEqual(viewModel.scale, viewModel.maxScale)
    }

    // MARK: - Coordinate Conversion Tests

    func testScreenToCanvasConversion() throws {
        viewModel.scale = 2.0
        viewModel.offset = CGPoint(x: 100, y: 100)

        let screenPoint = CGPoint(x: 300, y: 300)
        let canvasPoint = viewModel.screenToCanvas(screenPoint)

        XCTAssertEqual(canvasPoint.x, 100)
        XCTAssertEqual(canvasPoint.y, 100)
    }

    func testCanvasToScreenConversion() throws {
        viewModel.scale = 2.0
        viewModel.offset = CGPoint(x: 100, y: 100)

        let canvasPoint = CGPoint(x: 100, y: 100)
        let screenPoint = viewModel.canvasToScreen(canvasPoint)

        XCTAssertEqual(screenPoint.x, 300)
        XCTAssertEqual(screenPoint.y, 300)
    }

    // MARK: - Node Hit Testing Tests

    func testNodeAtPointReturnsNilForEmptyNodes() throws {
        let result = viewModel.nodeAt(point: CGPoint(x: 100, y: 100), nodes: [])

        XCTAssertNil(result)
    }

    func testNodeAtPointReturnsNode() throws {
        let node = MindMapNode(title: "Test", positionX: 100, positionY: 100, depth: 1)

        let result = viewModel.nodeAt(point: CGPoint(x: 100, y: 100), nodes: [node])

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, node.id)
    }

    func testNodeAtPointReturnsNilForPointOutsideNode() throws {
        let node = MindMapNode(title: "Test", positionX: 100, positionY: 100, depth: 1)

        let result = viewModel.nodeAt(point: CGPoint(x: 500, y: 500), nodes: [node])

        XCTAssertNil(result)
    }

    // MARK: - Selection Tests

    func testSelectNode() throws {
        let nodeID = UUID()

        viewModel.selectNode(nodeID)

        XCTAssertTrue(viewModel.selectedNodeIDs.contains(nodeID))
        XCTAssertEqual(viewModel.focusedNodeID, nodeID)
    }

    func testToggleSelection() throws {
        let nodeID = UUID()

        viewModel.toggleSelection(nodeID)
        XCTAssertTrue(viewModel.selectedNodeIDs.contains(nodeID))

        viewModel.toggleSelection(nodeID)
        XCTAssertFalse(viewModel.selectedNodeIDs.contains(nodeID))
    }

    func testClearSelection() throws {
        let nodeID1 = UUID()
        let nodeID2 = UUID()

        viewModel.selectedNodeIDs = [nodeID1, nodeID2]

        viewModel.clearSelection()

        XCTAssertTrue(viewModel.selectedNodeIDs.isEmpty)
    }

    func testSelectAll() throws {
        let nodeIDs = [UUID(), UUID(), UUID()]

        viewModel.selectAll(nodeIDs: nodeIDs)

        XCTAssertEqual(viewModel.selectedNodeIDs.count, 3)
    }

    // MARK: - Has Selection Tests

    func testHasSelectionReturnsTrueWhenNodesSelected() throws {
        viewModel.selectedNodeIDs.insert(UUID())

        XCTAssertTrue(viewModel.hasSelection)
    }

    func testHasSelectionReturnsFalseWhenNoSelection() throws {
        XCTAssertFalse(viewModel.hasSelection)
    }

    // MARK: - Visible Rect Tests

    func testVisibleRectCalculation() throws {
        viewModel.scale = 2.0
        viewModel.offset = CGPoint(x: 100, y: 100)
        viewModel.canvasSize = CGSize(width: 800, height: 600)

        let visibleRect = viewModel.visibleRect

        XCTAssertGreaterThan(visibleRect.width, 0)
        XCTAssertGreaterThan(visibleRect.height, 0)
    }

    // MARK: - Scale Limits Tests

    func testMinScaleIsDefined() throws {
        XCTAssertEqual(viewModel.minScale, 0.1)
    }

    func testMaxScaleIsDefined() throws {
        XCTAssertEqual(viewModel.maxScale, 3.0)
    }

    // MARK: - Grid Settings Tests

    func testGridToggle() throws {
        viewModel.showGrid = false
        XCTAssertFalse(viewModel.showGrid)

        viewModel.showGrid = true
        XCTAssertTrue(viewModel.showGrid)
    }

    func testGridSpacingDefault() throws {
        XCTAssertEqual(viewModel.gridSpacing, 20)
    }
}
