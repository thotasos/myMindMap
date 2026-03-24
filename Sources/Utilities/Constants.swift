import Foundation
import CoreGraphics

enum AppConstants {
    // MARK: - Canvas
    enum Canvas {
        static let defaultScale: CGFloat = 1.0
        static let minScale: CGFloat = 0.1
        static let maxScale: CGFloat = 4.0
        static let gridSpacing: CGFloat = 20
        static let defaultZoomStep: CGFloat = 1.25
    }

    // MARK: - Node
    enum Node {
        static let defaultWidth: CGFloat = 120
        static let defaultHeight: CGFloat = 40
        static let centralNodeHeight: CGFloat = 60
        static let minWidth: CGFloat = 100
        static let maxWidth: CGFloat = 300
        static let minHeight: CGFloat = 30
        static let maxHeight: CGFloat = 150
        static let cornerRadius: CGFloat = 8
        static let maxTitleLength = 10000
        static let maxNotesLength = 10000

        // Font sizes by depth
        static let fontSizeDepth0: CGFloat = 24
        static let fontSizeDepth1: CGFloat = 18
        static let fontSizeDepth2: CGFloat = 14
        static let fontSizeDepth3Plus: CGFloat = 12
        static let notesFontSize: CGFloat = 10
    }

    // MARK: - Connection
    enum Connection {
        static let defaultColorHue: Double = 0.0
        static let defaultSaturation: Double = 1.0
        static let defaultBrightness: Double = 0.7
        static let lineWidth: CGFloat = 1.5
        static let curvedControlOffset: CGFloat = 0.5
    }

    // MARK: - Layout
    enum Layout {
        static let horizontalSpacing: CGFloat = 150
        static let verticalSpacing: CGFloat = 60
        static let padding: CGFloat = 50
        static let childNodeOffset: CGFloat = 150
    }

    // MARK: - Animation
    enum Animation {
        static let defaultDuration: Double = 0.3
        static let quickDuration: Double = 0.15
        static let expandCollapseDuration: Double = 0.25
    }

    // MARK: - Auto-Save
    enum AutoSave {
        static let interval: TimeInterval = 30
    }

    // MARK: - Export
    enum Export {
        static let pngScale: CGFloat = 2.0
        static let supportedFormats = ["JSON", "Markdown", "PNG"]
    }

    // MARK: - Colors
    enum Colors {
        static let defaultBackground = "#FFFFFF"
        static let defaultNodeBackground = "#F5F5F5"
        static let defaultNodeText = "#000000"
        static let defaultConnection = "#888888"
        static let selectionColor = "#007AFF"
    }

    // MARK: - Connector Hues
    enum ConnectorHues {
        static let hues: [Double] = [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875]
        static let saturation: Double = 1.0
        static let brightness: Double = 0.7
    }
}
