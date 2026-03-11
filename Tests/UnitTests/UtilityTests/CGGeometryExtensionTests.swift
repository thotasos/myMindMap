import XCTest
import CoreGraphics
@testable import myMindMap

final class CGSizeExtensionTests: XCTestCase {

    // MARK: - Addition Tests

    func testSizeAddition() throws {
        let size1 = CGSize(width: 10, height: 20)
        let size2 = CGSize(width: 5, height: 10)

        let result = size1 + size2

        XCTAssertEqual(result.width, 15)
        XCTAssertEqual(result.height, 30)
    }

    // MARK: - Subtraction Tests

    func testSizeSubtraction() throws {
        let size1 = CGSize(width: 10, height: 20)
        let size2 = CGSize(width: 5, height: 10)

        let result = size1 - size2

        XCTAssertEqual(result.width, 5)
        XCTAssertEqual(result.height, 10)
    }

    // MARK: - Center Property Tests

    func testCenterProperty() throws {
        let size = CGSize(width: 100, height: 50)

        let center = size.center

        XCTAssertEqual(center.x, 50)
        XCTAssertEqual(center.y, 25)
    }

    func testCenterWithOddDimensions() throws {
        let size = CGSize(width: 101, height: 51)

        let center = size.center

        XCTAssertEqual(center.x, 50.5)
        XCTAssertEqual(center.y, 25.5)
    }
}

final class CGRectExtensionTests: XCTestCase {

    // MARK: - Center Property Tests

    func testRectCenter() throws {
        let rect = CGRect(x: 10, y: 20, width: 100, height: 50)

        let center = rect.center

        XCTAssertEqual(center.x, 60)
        XCTAssertEqual(center.y, 45)
    }

    // MARK: - Init with Center Tests

    func testInitWithCenter() throws {
        let center = CGPoint(x: 50, y: 50)
        let size = CGSize(width: 100, height: 40)

        let rect = CGRect(center: center, size: size)

        XCTAssertEqual(rect.origin.x, 0)
        XCTAssertEqual(rect.origin.y, 30)
        XCTAssertEqual(rect.width, 100)
        XCTAssertEqual(rect.height, 40)
    }

    // MARK: - Expanded Tests

    func testExpanded() throws {
        let rect = CGRect(x: 10, y: 20, width: 100, height: 50)

        let expanded = rect.expanded(by: 5)

        XCTAssertEqual(expanded.origin.x, 5)
        XCTAssertEqual(expanded.origin.y, 15)
        XCTAssertEqual(expanded.width, 110)
        XCTAssertEqual(expanded.height, 60)
    }

    // MARK: - Contains in Coordinate Space Tests

    func testContainsInCoordinateSpace() throws {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let coordinateSpace = CGSize(width: 200, height: 200)

        let contains = rect.contains(CGPoint(x: 50, y: 50), in: coordinateSpace)

        XCTAssertTrue(contains)
    }

    func testContainsInCoordinateSpaceOutside() throws {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let coordinateSpace = CGSize(width: 200, height: 200)

        let contains = rect.contains(CGPoint(x: 150, y: 150), in: coordinateSpace)

        XCTAssertFalse(contains)
    }

    func testContainsInCoordinateSpaceWithZeroSize() throws {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)

        let contains = rect.contains(CGPoint(x: 50, y: 50), in: .zero)

        XCTAssertFalse(contains)
    }

    func testContainsInCoordinateSpaceNormalized() throws {
        // Testing normalized coordinates
        let rect = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
        let coordinateSpace = CGSize(width: 1, height: 1)

        // Point at center of rect in normalized space
        let contains = rect.contains(CGPoint(x: 0.5, y: 0.5), in: coordinateSpace)

        XCTAssertTrue(contains)
    }
}
