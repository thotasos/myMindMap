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
            MindMapConnection.self,
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

            CommandGroup(after: .help) {
                Button("Keyboard Shortcuts") {
                    NotificationCenter.default.post(name: .showShortcuts, object: nil)
                }
                .keyboardShortcut("?", modifiers: .command)
            }
        }
    }
}
