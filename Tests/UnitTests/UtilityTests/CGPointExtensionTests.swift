import XCTest
import CoreGraphics
@testable import myMindMap

final class CGPointExtensionTests: XCTestCase {

    // MARK: - Addition Tests

    func testPointAddition() throws {
        let point1 = CGPoint(x: 10, y: 20)
        let point2 = CGPoint(x: 5, y: 10)

        let result = point1 + point2

        XCTAssertEqual(result.x, 15)
        XCTAssertEqual(result.y, 30)
    }

    func testPointAdditionWithNegative() throws {
        let point1 = CGPoint(x: 10, y: 20)
        let point2 = CGPoint(x: -5, y: -10)

        let result = point1 + point2

        XCTAssertEqual(result.x, 5)
        XCTAssertEqual(result.y, 10)
    }

    // MARK: - Subtraction Tests

    func testPointSubtraction() throws {
        let point1 = CGPoint(x: 10, y: 20)
        let point2 = CGPoint(x: 5, y: 10)

        let result = point1 - point2

        XCTAssertEqual(result.x, 5)
        XCTAssertEqual(result.y, 10)
    }

    func testPointSubtractionWithNegativeResult() throws {
        let point1 = CGPoint(x: 5, y: 10)
        let point2 = CGPoint(x: 10, y: 20)

        let result = point1 - point2

        XCTAssertEqual(result.x, -5)
        XCTAssertEqual(result.y, -10)
    }

    // MARK: - Multiplication Tests

    func testPointMultiplication() throws {
        let point = CGPoint(x: 10, y: 20)

        let result = point * 2

        XCTAssertEqual(result.x, 20)
        XCTAssertEqual(result.y, 40)
    }

    func testPointMultiplicationWithFraction() throws {
        let point = CGPoint(x: 10, y: 20)

        let result = point * 0.5

        XCTAssertEqual(result.x, 5)
        XCTAssertEqual(result.y, 10)
    }

    // MARK: - Division Tests

    func testPointDivision() throws {
        let point = CGPoint(x: 20, y: 40)

        let result = point / 2

        XCTAssertEqual(result.x, 10)
        XCTAssertEqual(result.y, 20)
    }

    func testPointDivisionWithZero() throws {
        let point = CGPoint(x: 10, y: 20)

        // Division by zero should result in infinity
        let result = point / 0

        XCTAssertTrue(result.x.isInfinite)
        XCTAssertTrue(result.y.isInfinite)
    }

    // MARK: - Distance Tests

    func testDistanceToSamePoint() throws {
        let point = CGPoint(x: 10, y: 20)

        let distance = point.distance(to: point)

        XCTAssertEqual(distance, 0)
    }

    func testDistanceToHorizontalPoint() throws {
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 3, y: 0)

        let distance = point1.distance(to: point2)

        XCTAssertEqual(distance, 3)
    }

    func testDistanceToVerticalPoint() throws {
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 0, y: 4)

        let distance = point1.distance(to: point2)

        XCTAssertEqual(distance, 4)
    }

    func testDistanceToDiagonalPoint() throws {
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 3, y: 4)

        let distance = point1.distance(to: point2)

        XCTAssertEqual(distance, 5) // 3-4-5 triangle
    }

    func testDistanceIsSymmetric() throws {
        let point1 = CGPoint(x: 10, y: 20)
        let point2 = CGPoint(x: 30, y: 40)

        let distance1 = point1.distance(to: point2)
        let distance2 = point2.distance(to: point1)

        XCTAssertEqual(distance1, distance2)
    }

    // MARK: - Midpoint Tests

    func testMidPointToSamePoint() throws {
        let point = CGPoint(x: 10, y: 20)

        let midPoint = point.midPoint(to: point)

        XCTAssertEqual(midPoint.x, 10)
        XCTAssertEqual(midPoint.y, 20)
    }

    func testMidPoint() throws {
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 10, y: 20)

        let midPoint = point1.midPoint(to: point2)

        XCTAssertEqual(midPoint.x, 5)
        XCTAssertEqual(midPoint.y, 10)
    }

    func testMidPointWithNegativeCoordinates() throws {
        let point1 = CGPoint(x: -10, y: -20)
        let point2 = CGPoint(x: 10, y: 20)

        let midPoint = point1.midPoint(to: point2)

        XCTAssertEqual(midPoint.x, 0)
        XCTAssertEqual(midPoint.y, 0)
    }

    // MARK: - Angle Tests

    func testAngleToHorizontalRight() throws {
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 10, y: 0)

        let angle = point1.angle(to: point2)

        XCTAssertEqual(angle, 0)
    }

    func testAngleToHorizontalLeft() throws {
        let point1 = CGPoint(x: 10, y: 0)
        let point2 = CGPoint(x: 0, y: 0)

        let angle = point1.angle(to: point2)

        XCTAssertEqual(angle, .pi)
    }

    func testAngleToVerticalUp() throws {
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 0, y: 10)

        let angle = point1.angle(to: point2)

        XCTAssertEqual(angle, .pi / 2)
    }

    func testAngleToVerticalDown() throws {
        let point1 = CGPoint(x: 0, y: 10)
        let point2 = CGPoint(x: 0, y: 0)

        let angle = point1.angle(to: point2)

        XCTAssertEqual(angle, -.pi / 2)
    }

    // MARK: - Rotation Tests

    func testRotateAroundOrigin() throws {
        let point = CGPoint(x: 10, y: 0)
        let center = CGPoint(x: 0, y: 0)

        let rotated = point.rotated(around: center, by: .pi / 2)

        // Due to floating point, use approximate equality
        XCTAssertEqual(rotated.x, 0, accuracy: 0.0001)
        XCTAssertEqual(rotated.y, 10, accuracy: 0.0001)
    }

    func testRotateAroundNonOrigin() throws {
        let point = CGPoint(x: 10, y: 10)
        let center = CGPoint(x: 5, y: 5)

        let rotated = point.rotated(around: center, by: .pi)

        XCTAssertEqual(rotated.x, 0, accuracy: 0.0001)
        XCTAssertEqual(rotated.y, 0, accuracy: 0.0001)
    }

    func testRotate360Degrees() throws {
        let point = CGPoint(x: 10, y: 0)
        let center = CGPoint(x: 0, y: 0)

        let rotated = point.rotated(around: center, by: .pi * 2)

        XCTAssertEqual(rotated.x, 10, accuracy: 0.0001)
        XCTAssertEqual(rotated.y, 0, accuracy: 0.0001)
    }
}
