import Foundation
import SwiftData
import CoreGraphics

@Model
final class MindMapNode {
    @Attribute(.unique) var id: UUID
    var title: String
    var notes: String
    var positionX: Double
    var positionY: Double
    var depth: Int
    var isExpanded: Bool
    var parentId: UUID?
    var colorHue: Double
    var colorSaturation: Double
    var colorBrightness: Double

    @Relationship(deleteRule: .cascade)
    var children: [MindMapNode]

    var mindMap: MindMap?

    init(
        id: UUID = UUID(),
        title: String = "",
        notes: String = "",
        positionX: Double = 0,
        positionY: Double = 0,
        depth: Int = 0,
        isExpanded: Bool = true,
        parentId: UUID? = nil,
        colorHue: Double = 0.0,
        colorSaturation: Double = 1.0,
        colorBrightness: Double = 0.7,
        mindMap: MindMap? = nil,
        children: [MindMapNode] = []
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.positionX = positionX
        self.positionY = positionY
        self.depth = depth
        self.isExpanded = isExpanded
        self.parentId = parentId
        self.colorHue = colorHue
        self.colorSaturation = colorSaturation
        self.colorBrightness = colorBrightness
        self.mindMap = mindMap
        self.children = children
    }

    var position: CGPoint {
        get { CGPoint(x: positionX, y: positionY) }
        set {
            positionX = newValue.x
            positionY = newValue.y
        }
    }

    var colorHex: String {
        get {
            let hue = Int(colorHue * 360)
            let sat = Int(colorSaturation * 100)
            let bri = Int(colorBrightness * 100)
            return "#\(hue)_\(sat)_\(bri)"
        }
        set {
            // Parse hex format: #H_S_B
            let components = newValue.dropFirst().split(separator: "_")
            if components.count == 3,
               let h = Double(components[0]),
               let s = Double(components[1]),
               let b = Double(components[2]) {
                colorHue = h / 360.0
                colorSaturation = s / 100.0
                colorBrightness = b / 100.0
            }
        }
    }

    var fontSize: CGFloat {
        switch depth {
        case 0: return 24
        case 1: return 18
        case 2: return 14
        default: return 12
        }
    }

    var frame: CGRect {
        let width: CGFloat = 120
        let height: CGFloat = depth == 0 ? 60 : 40
        return CGRect(
            x: positionX - width / 2,
            y: positionY - height / 2,
            width: width,
            height: height
        )
    }
}

extension MindMapNode: Identifiable { }
