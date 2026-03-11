import Foundation
import SwiftUI

@Observable
class KeyboardViewModel {
    var isCommandMode: Bool = false
    var lastKeyPress: String = ""

    func handleKeyPress(_ key: KeyEquivalent, modifiers: EventModifiers) -> Bool {
        // Default key handling
        switch (key, modifiers) {
        // Navigation
        case (.tab, []):
            lastKeyPress = "Tab"
            return false // Let the view handle it

        case (.return, []):
            lastKeyPress = "Return"
            return false

        case (.delete, []):
            lastKeyPress = "Delete"
            return false

        case (.escape, []):
            lastKeyPress = "Escape"
            return false

        // Arrow keys
        case (.upArrow, []):
            lastKeyPress = "Up"
            return false

        case (.downArrow, []):
            lastKeyPress = "Down"
            return false

        case (.leftArrow, []):
            lastKeyPress = "Left"
            return false

        case (.rightArrow, []):
            lastKeyPress = "Right"
            return false

        // Command shortcuts
        case ("n", .command):
            lastKeyPress = "Cmd+N"
            NotificationCenter.default.post(name: .createNewMindMap, object: nil)
            return true

        case ("s", .command):
            lastKeyPress = "Cmd+S"
            NotificationCenter.default.post(name: .saveMindMap, object: nil)
            return true

        case ("z", .command):
            lastKeyPress = "Cmd+Z"
            NotificationCenter.default.post(name: .undoAction, object: nil)
            return true

        case ("z", [.command, .shift]):
            lastKeyPress = "Cmd+Shift+Z"
            NotificationCenter.default.post(name: .redoAction, object: nil)
            return true

        case ("d", .command):
            lastKeyPress = "Cmd+D"
            NotificationCenter.default.post(name: .duplicateNode, object: nil)
            return true

        case ("f", .command):
            lastKeyPress = "Cmd+F"
            NotificationCenter.default.post(name: .showSearch, object: nil)
            return true

        case ("0", .command):
            lastKeyPress = "Cmd+0"
            NotificationCenter.default.post(name: .fitToScreen, object: nil)
            return true

        case ("=", .command), ("+", .command):
            lastKeyPress = "Cmd++"
            NotificationCenter.default.post(name: .zoomIn, object: nil)
            return true

        case ("-", .command):
            lastKeyPress = "Cmd+-"
            NotificationCenter.default.post(name: .zoomOut, object: nil)
            return true

        default:
            lastKeyPress = "\(key)"
            return false
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let saveMindMap = Notification.Name("saveMindMap")
    static let undoAction = Notification.Name("undoAction")
    static let redoAction = Notification.Name("redoAction")
    static let duplicateNode = Notification.Name("duplicateNode")
    static let showSearch = Notification.Name("showSearch")
    static let fitToScreen = Notification.Name("fitToScreen")
    static let zoomIn = Notification.Name("zoomIn")
    static let zoomOut = Notification.Name("zoomOut")
}
