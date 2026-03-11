import SwiftUI
import SwiftData

@main
struct MyMindMapApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            MindMap.self,
            MindMapNode.self,
            NodeConnection.self,
            Theme.self
        ])
        .windowStyle(.automatic)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Mind Map") {
                    NotificationCenter.default.post(name: .createNewMindMap, object: nil)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
    }
}

extension Notification.Name {
    static let createNewMindMap = Notification.Name("createNewMindMap")
}
