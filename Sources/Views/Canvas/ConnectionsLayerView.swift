import SwiftUI

struct ConnectionsLayerView: View {
    let mindMap: MindMap
    @Bindable var canvasViewModel: CanvasViewModel

    var body: some View {
        Canvas { context, size in
            for connection in mindMap.connections {
                guard let source = connection.sourceNode,
                      let target = connection.targetNode else { continue }

                // Skip collapsed nodes
                if source.isCollapsed { continue }

                let path = createConnectionPath(
                    from: source.position,
                    to: target.position,
                    style: connection.style
                )

                let color = Color(hex: connection.colorHex) ?? .gray

                context.stroke(
                    path,
                    with: .color(color.opacity(0.6)),
                    lineWidth: 2
                )
            }
        }
    }

    private func createConnectionPath(from: CGPoint, to: CGPoint, style: ConnectionStyle) -> Path {
        switch style {
        case .straight:
            return createStraightPath(from: from, to: to)

        case .curved:
            return createCurvedPath(from: from, to: to)

        case .bezier:
            return createBezierPath(from: from, to: to)
        }
    }

    private func createStraightPath(from: CGPoint, to: CGPoint) -> Path {
        var path = Path()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }

    private func createCurvedPath(from: CGPoint, to: CGPoint) -> Path {
        var path = Path()
        path.move(to: from)

        let midX = (from.x + to.x) / 2

        path.addCurve(
            to: to,
            control1: CGPoint(x: midX, y: from.y),
            control2: CGPoint(x: midX, y: to.y)
        )

        return path
    }

    private func createBezierPath(from: CGPoint, to: CGPoint) -> Path {
        var path = Path()

        let controlOffset = abs(to.x - from.x) * 0.5

        path.move(to: from)
        path.addCurve(
            to: to,
            control1: CGPoint(x: from.x + controlOffset, y: from.y),
            control2: CGPoint(x: to.x - controlOffset, y: to.y)
        )

        return path
    }
}
