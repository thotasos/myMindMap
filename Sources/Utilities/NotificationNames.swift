import Foundation

// MARK: - Notification Names

extension Notification.Name {
    static let createNewMindMap = Notification.Name("createNewMindMap")
    static let saveMindMap = Notification.Name("saveMindMap")
    static let undoAction = Notification.Name("undoAction")
    static let redoAction = Notification.Name("redoAction")
    static let duplicateNode = Notification.Name("duplicateNode")
    static let showSearch = Notification.Name("showSearch")
    static let showShortcuts = Notification.Name("showShortcuts")
    static let fitToScreen = Notification.Name("fitToScreen")
    static let zoomIn = Notification.Name("zoomIn")
    static let zoomOut = Notification.Name("zoomOut")
    static let zoomTo100 = Notification.Name("zoomTo100")
    static let navigateBack = Notification.Name("navigateBack")
    static let navigateForward = Notification.Name("navigateForward")
    static let collapseAll = Notification.Name("collapseAll")
    static let expandAll = Notification.Name("expandAll")
    static let deleteNode = Notification.Name("deleteNode")
    static let addChildNode = Notification.Name("addChildNode")
    static let addSiblingNode = Notification.Name("addSiblingNode")
    static let toggleFullscreen = Notification.Name("toggleFullscreen")
    static let toggleExpand = Notification.Name("toggleExpand")
}
