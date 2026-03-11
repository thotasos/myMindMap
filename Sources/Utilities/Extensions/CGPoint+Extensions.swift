import Foundation
import CoreGraphics

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    static func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    func distance(to point: CGPoint) -> CGFloat {
        let dx = x - point.x
        let dy = y - point.y
        return sqrt(dx * dx + dy * dy)
    }

    func midPoint(to point: CGPoint) -> CGPoint {
        CGPoint(x: (x + point.x) / 2, y: (y + point.y) / 2)
    }

    func angle(to point: CGPoint) -> CGFloat {
        atan2(point.y - y, point.x - x)
    }

    func rotated(around center: CGPoint, by angle: CGFloat) -> CGPoint {
        let dx = x - center.x
        let dy = y - center.y
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)

        return CGPoint(
            x: center.x + dx * cosAngle - dy * sinAngle,
            y: center.y + dx * sinAngle + dy * cosAngle
        )
    }
}

extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    var center: CGPoint {
        CGPoint(x: width / 2, y: height / 2)
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }

    init(center: CGPoint, size: CGSize) {
        self.init(
            x: center.x - size.width / 2,
            y: center.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }

    func expanded(by amount: CGFloat) -> CGRect {
        insetBy(dx: -amount, dy: -amount)
    }

    func contains(_ point: CGPoint, in coordinateSpace: CGSize) -> Bool {
        guard coordinateSpace.width > 0, coordinateSpace.height > 0 else {
            return false
        }

        let normalizedPoint = CGPoint(
            x: point.x / coordinateSpace.width,
            y: point.y / coordinateSpace.height
        )

        let normalizedRect = CGRect(
            x: minX / coordinateSpace.width,
            y: minY / coordinateSpace.height,
            width: width / coordinateSpace.width,
            height: height / coordinateSpace.height
        )

        return normalizedRect.contains(normalizedPoint)
    }
}
