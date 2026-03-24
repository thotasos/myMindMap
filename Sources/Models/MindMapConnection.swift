import Foundation
import SwiftData

@Model
final class MindMapConnection {
    @Attribute(.unique) var id: UUID
    var sourceNodeId: UUID
    var targetNodeId: UUID
    var colorHue: Double
    var colorSaturation: Double
    var colorBrightness: Double

    var mindMap: MindMap?

    init(
        id: UUID = UUID(),
        sourceNodeId: UUID,
        targetNodeId: UUID,
        colorHue: Double = 0.0,
        colorSaturation: Double = 1.0,
        colorBrightness: Double = 0.7,
        mindMap: MindMap? = nil
    ) {
        self.id = id
        self.sourceNodeId = sourceNodeId
        self.targetNodeId = targetNodeId
        self.colorHue = colorHue
        self.colorSaturation = colorSaturation
        self.colorBrightness = colorBrightness
        self.mindMap = mindMap
    }

    var colorHex: String {
        let hue = Int(colorHue * 360)
        let sat = Int(colorSaturation * 100)
        let bri = Int(colorBrightness * 100)
        return "#\(hue)_\(sat)_\(bri)"
    }
}

extension MindMapConnection: Identifiable { }
