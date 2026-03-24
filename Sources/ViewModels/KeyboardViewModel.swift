import Foundation
import SwiftUI

@Observable
@MainActor
final class KeyboardViewModel {
    var isCommandMode: Bool = false
    var lastKeyPress: String = ""

    func handleKeyPress(_ key: KeyEquivalent, modifiers: EventModifiers) -> Bool {
        switch (key, modifiers) {
        // Navigation
        case (.tab, []):
            lastKeyPress = "Tab"
            return false

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

        case ("1", .command):
            lastKeyPress = "Cmd+1"
            NotificationCenter.default.post(name: .zoomTo100, object: nil)
            return true

        case ("=", .command), ("+", .command):
            lastKeyPress = "Cmd++"
            NotificationCenter.default.post(name: .zoomIn, object: nil)
            return true

        case ("-", .command):
            lastKeyPress = "Cmd+-"
            NotificationCenter.default.post(name: .zoomOut, object: nil)
            return true

        case ("?", .command):
            lastKeyPress = "Cmd+?"
            NotificationCenter.default.post(name: .showShortcuts, object: nil)
            return true

        case (" ", []):
            lastKeyPress = "Space"
            return false

        case ("[", .command):
            lastKeyPress = "Cmd+["
            NotificationCenter.default.post(name: .navigateBack, object: nil)
            return true

        case ("]", .command):
            lastKeyPress = "Cmd+]"
            NotificationCenter.default.post(name: .navigateForward, object: nil)
            return true

        case ("c", [.command, .shift]):
            lastKeyPress = "Cmd+Shift+C"
            NotificationCenter.default.post(name: .collapseAll, object: nil)
            return true

        case ("e", [.command, .shift]):
            lastKeyPress = "Cmd+Shift+E"
            NotificationCenter.default.post(name: .expandAll, object: nil)
            return true

        default:
            lastKeyPress = "\(key)"
            return false
        }
    }
}

// Notification names are defined in NotificationNames.swift
