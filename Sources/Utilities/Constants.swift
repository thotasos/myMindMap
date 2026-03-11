import Foundation

enum AppConstants {
    // MARK: - Canvas
    enum Canvas {
        static let defaultScale: CGFloat = 1.0
        static let minScale: CGFloat = 0.1
        static let maxScale: CGFloat = 3.0
        static let gridSpacing: CGFloat = 20
        static let defaultZoomStep: CGFloat = 1.2
    }

    // MARK: - Node
    enum Node {
        static let defaultWidth: CGFloat = 120
        static let defaultHeight: CGFloat = 40
        static let minWidth: CGFloat = 60
        static let maxWidth: CGFloat = 300
        static let minHeight: CGFloat = 30
        static let maxHeight: CGFloat = 150
        static let defaultFontSize: CGFloat = 14
        static let cornerRadius: CGFloat = 8
    }

    // MARK: - Connection
    enum Connection {
        static let defaultColor: String = "#888888"
        static let defaultLineWidth: CGFloat = 2
        static let curvedControlOffset: CGFloat = 0.5
    }

    // MARK: - Layout
    enum Layout {
        static let horizontalSpacing: CGFloat = 150
        static let verticalSpacing: CGFloat = 60
        static let padding: CGFloat = 50
    }

    // MARK: - Animation
    enum Animation {
        static let defaultDuration: Double = 0.3
        static let quickDuration: Double = 0.15
    }

    // MARK: - Export
    enum Export {
        static let pngScale: CGFloat = 2.0
        static let supportedFormats = ["JSON", "Markdown", "PNG"]
    }

    // MARK: - Keyboard
    enum Keyboard {
        static let zoomInShortcut = "+"
        static let zoomOutShortcut = "-"
        static let fitToScreenShortcut = "0"
    }

    // MARK: - Colors
    enum Colors {
        static let defaultBackground = "#FFFFFF"
        static let defaultNodeBackground = "#F5F5F5"
        static let defaultNodeText = "#000000"
        static let defaultConnection = "#888888"
        static let selectionColor = "#007AFF"
    }
}
