# Technical Architecture: myMindMap

**Version:** 1.0
**Date:** 2026-03-10
**Status:** Draft

---

## 1. Architecture Overview

### 1.1 Design Pattern: MVVM with SwiftUI

The application follows the **Model-View-ViewModel (MVVM)** pattern, leveraging SwiftUI's reactive data binding capabilities. This architecture provides:

- **Separation of Concerns**: Clear boundaries between UI (Views), business logic (ViewModels), and data (Models)
- **Testability**: ViewModels can be unit tested independently of SwiftUI views
- **Reactive Updates**: SwiftUI's @Observable and @StateObject properties ensure automatic UI updates
- **SwiftData Integration**: Seamless persistence with SwiftData's model container and context

### 1.2 Layer Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      Views Layer                        │
│  (SwiftUI Views: CanvasView, NodeView, ToolbarView)    │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                   ViewModels Layer                      │
│  (CanvasViewModel, NodeViewModel, MindMapViewModel,    │
│   KeyboardViewModel)                                    │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                     Models Layer                        │
│  (MindMap, MindMapNode, NodeConnection, Theme - SwiftData)        │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    Persistence Layer                    │
│           (SwiftData with SQLite backend)              │
└─────────────────────────────────────────────────────────┘
```

### 1.3 Data Flow

```
User Input (Keyboard/Mouse)
         │
         ▼
    ┌─────────┐
    │  Views  │ <-- SwiftUI renders ViewModels' state
    └────┬────┘
         │ @Binding / @Observable
         ▼
┌──────────────────────────────────────────────────────────┐
│                      ViewModels                          │
│  ┌────────────────┐ ┌────────────────┐ ┌─────────────┐│
│  │MindMapViewModel│ │CanvasViewModel │ │NodeViewModel│ │
│  └───────┬────────┘ └───────┬────────┘ └──────┬────────┘│
└──────────┼──────────────────┼─────────────────┼─────────┘
           │                  │                 │
           ▼                  ▼                 ▼
┌──────────────────────────────────────────────────────────┐
│                      Models (SwiftData)                   │
│  ┌──────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │ MindMap  │──│ MindMapNode  │──│NodeConnection│        │
│  └──────────┘  └──────────────┘  └──────────────┘        │
└──────────────────────────────────────────────────────────┘
           │
           ▼
    SQLite Database
```

---

## 2. Data Models

### 2.1 SwiftData Models

All data models use SwiftData's `@Model` macro for automatic persistence.

#### MindMap
```swift
@Model
class MindMap {
    var id: UUID
    var title: String
    var createdAt: Date
    var modifiedAt: Date
    var rootNode: MindMapNode?
    @Relationship(deleteRule: .cascade) var nodes: [MindMapNode]
    @Relationship(deleteRule: .cascade) var connections: [NodeConnection]
}
```

#### MindMapNode (Node)
```swift
@Model
final class MindMapNode {
    var id: UUID
    var text: String
    var positionX: Double
    var positionY: Double
    var width: Double
    var height: Double
    var backgroundColorHex: String
    var textColorHex: String
    var fontSize: Double
    var isCollapsed: Bool
    var createdAt: Date
    var parent: MindMapNode?
    @Relationship(inverse: \MindMapNode.parent) var children: [MindMapNode]
    var outgoingConnections: [NodeConnection]
    var incomingConnections: [NodeConnection]
    var mindMap: MindMap?
}
```

#### NodeConnection (Connection)
```swift
@Model
final class NodeConnection {
    var id: UUID
    var styleRawValue: String
    var colorHex: String
    var createdAt: Date
    var sourceNode: MindMapNode?
    var targetNode: MindMapNode?
    var mindMap: MindMap?
}
```

#### Theme
```swift
@Model
class Theme {
    var id: UUID
    var name: String
    var backgroundColor: String
    var nodeBackgroundColor: String
    var nodeTextColor: String
    var connectionColor: String
    var isDarkMode: Bool
    var isDefault: Bool
}
```

### 2.2 Enums

```swift
enum ConnectionStyle: String, Codable {
    case straight
    case curved
    case bezier
}

enum NodeLevel: Int, Codable {
    case root = 0
    case primary = 1
    case secondary = 2
    case tertiary = 3
}
```

---

## 3. ViewModels

### 3.1 MindMapViewModel

**Responsibility**: Manages the overall mind map document lifecycle

```swift
@Observable
class MindMapViewModel {
    // Published properties
    var currentMindMap: MindMap?
    var recentMindMaps: [MindMap]
    var isDirty: Bool

    // Methods
    func createNewMap(title: String)
    func openMindMap(id: UUID)
    func saveMindMap()
    func deleteMindMap(id: UUID)
    func exportToJSON() -> Data?
    func exportToMarkdown() -> String?
    func exportToPNG() -> NSImage?
}
```

### 3.2 CanvasViewModel

**Responsibility**: Manages canvas state, pan/zoom, and viewport calculations

```swift
@Observable
class CanvasViewModel {
    // Viewport state
    var scale: CGFloat = 1.0
    var offset: CGPoint = .zero
    var visibleRect: CGRect

    // Selection state
    var selectedNodeIDs: Set<UUID>
    var focusedNodeID: UUID?

    // Methods
    func zoomIn()
    func zoomOut()
    func fitToScreen()
    func pan(by delta: CGPoint)
    func nodeAt(point: CGPoint) -> Node?
    func visibleNodes() -> [Node]
}
```

### 3.3 NodeViewModel

**Responsibility**: Manages node editing and manipulation

```swift
@Observable
class NodeViewModel {
    // Node state
    var editingNodeID: UUID?
    var editText: String

    // Methods
    func addChildNode(to nodeID: UUID) -> Node
    func addSiblingNode(to nodeID: UUID) -> Node
    func deleteNode(id: UUID)
    func duplicateNode(id: UUID) -> Node?
    func moveNode(id: UUID, to position: CGPoint)
    func collapseNode(id: UUID)
    func expandNode(id: UUID)
}
```

### 3.4 KeyboardViewModel

**Responsibility**: Handles keyboard shortcut processing and command routing

```swift
@Observable
class KeyboardViewModel {
    // Command state
    var isCommandMode: Bool
    var lastKeyPress: KeyEquivalent

    // Methods
    func handleKeyPress(_ key: KeyEquivalent, modifiers: EventModifiers) -> Bool
    func registerShortcut(_ shortcut: KeyboardShortcut, action: () -> Void)
}
```

---

## 4. Views

### 4.1 Main Window Structure

```
┌─────────────────────────────────────────────────────────┐
│  Menu Bar (File, Edit, View, Node, Help)               │
├─────────────────────────────────────────────────────────┤
│  Toolbar (New, Save, Export, Undo, Redo, Zoom)         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│                   Canvas View                           │
│    ┌─────────┐                                         │
│    │  Root   │──────┐                                  │
│    │  Node   │      ▼                                  │
│    └─────────┘   ┌─────────┐                           │
│                  │ Child   │                           │
│                  └─────────┘                           │
│                                                         │
├─────────────────────────────────────────────────────────┤
│  Status Bar (Node count, Zoom level, Save status)      │
└─────────────────────────────────────────────────────────┘
```

### 4.2 Core Views

| View | Responsibility |
|------|---------------|
| `MyMindMapApp.swift` | App entry point, SwiftData container setup |
| `ContentView.swift` | Main window content, window configuration |
| `CanvasView.swift` | Infinite canvas with pan/zoom gestures |
| `NodeView.swift` | Individual node rendering and interaction |
| `ConnectionView.swift` | Bezier curve connections between nodes |
| `ToolbarView.swift` | Top toolbar with actions |
| `StatusBarView.swift` | Bottom status bar information |
| `SearchOverlayView.swift` | Search/filter overlay (Cmd+F) |
| `ExportSheetView.swift` | Export format selection dialog |

### 4.3 Canvas Rendering Approach

The canvas uses a **hybrid rendering approach**:

1. **SwiftUI Canvas (Canvas API)**: For rendering connections (bezier curves) efficiently at scale
2. **SwiftUI Views**: For nodes (NodeView) to leverage SwiftUI's text handling and accessibility
3. **GeometryReader**: For viewport calculations and hit testing

```swift
struct CanvasView: View {
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGPoint = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Canvas { context, size in
                    // Draw grid background if enabled
                }
                .scaleEffect(scale)

                // Connections layer
                ConnectionsLayerView()
                    .scaleEffect(scale)

                // Nodes layer
                NodesLayerView()
                    .scaleEffect(scale)
            }
            .offset(x: offset.x, y: offset.y)
            .gesture(panGesture)
            .gesture(magnificationGesture)
        }
    }
}
```

---

## 5. Keyboard Handling

Keyboard handling is managed through the `KeyboardViewModel` using SwiftUI's `onKeyPress` modifier.

### 5.1 KeyboardViewModel

Handles keyboard shortcut processing and command routing.

```swift
@Observable
class KeyboardViewModel {
    // Properties
    var isCommandMode: Bool
    var lastKeyPress: KeyEquivalent?

    // Methods
    func handleKeyPress(_ key: KeyEquivalent, modifiers: EventModifiers) -> Bool
}
```

### 5.2 Default Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd+N | New Mind Map |
| Cmd+S | Save |
| Cmd+Z | Undo |
| Cmd+Shift+Z | Redo |
| Tab | Add Child Node |
| Enter | Add Sibling Node / Edit |
| Delete/Backspace | Delete Node |
| Escape | Deselect / Cancel |
| Arrow Keys | Navigate Nodes |
| Cmd++ | Zoom In |
| Cmd+- | Zoom Out |
| Cmd+0 | Fit to Screen |
| Cmd+F | Search |
| Cmd+D | Duplicate Node |
| Cmd+Up/Down | Move Node |
| Cmd+Enter | Collapse/Expand |

---

## 6. Persistence Layer

### 6.1 SwiftData Configuration

```swift
// App entry point configuration
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
    }
}
```

### 6.2 Storage Location

- **Default**: App's Application Support directory (`~/Library/Application Support/myMindMap/`)
- **File Format**: SwiftData's default SQLite storage
- **Auto-save**: Changes saved automatically via SwiftData's observation system

---

## 8. Performance Considerations

### 8.1 Rendering Optimization

- **Viewport Culling**: Only render nodes within visible rect
- **Lazy Loading**: Use SwiftUI's lazy loading for large node collections
- **Connection Batching**: Draw all connections in single Canvas pass

### 8.2 Memory Management

- **Node Pooling**: Reuse node views when scrolling
- **Image Caching**: Cache exported images temporarily
- **SwiftData Fetch Limits**: Paginate when loading large maps

### 8.3 Targets

| Metric | Target |
|--------|--------|
| App Launch | < 1 second |
| Node Creation | < 50ms |
| Canvas FPS (500 nodes) | 60 fps |
| Auto-save Latency | < 100ms |

---

## 9. File Structure

Note: The current implementation follows this structure but may not include all files mentioned (e.g., Services are not yet implemented).

```
myMindMap/
├── Sources/
│   ├── App/
│   │   └── MyMindMapApp.swift          # App entry point, SwiftData container
│   ├── Models/
│   │   ├── MindMap.swift               # Mind map document model
│   │   ├── Node.swift                  # MindMapNode model
│   │   ├── Connection.swift           # NodeConnection model
│   │   └── Theme.swift                # Theme configuration
│   ├── ViewModels/
│   │   ├── MindMapViewModel.swift      # Mind map lifecycle management
│   │   ├── CanvasViewModel.swift       # Canvas state, pan/zoom, viewport
│   │   ├── NodeViewModel.swift         # Node editing and manipulation
│   │   └── KeyboardViewModel.swift     # Keyboard shortcut handling
│   ├── Views/
│   │   ├── ContentView.swift           # Main window content
│   │   ├── Canvas/
│   │   │   ├── CanvasView.swift        # Infinite canvas with pan/zoom
│   │   │   ├── ConnectionsLayerView.swift  # Bezier curve connections
│   │   │   └── NodesLayerView.swift    # Node layer rendering
│   │   ├── Nodes/
│   │   │   └── NodeView.swift          # Individual node rendering
│   │   ├── Toolbar/
│   │   │   └── ToolbarView.swift      # Toolbar with actions
│   │   └── Overlays/
│   │       ├── StatusBarView.swift     # Status bar information
│   │       └── SearchOverlayView.swift # Search/filter overlay
│   └── Utilities/
│       ├── Extensions/
│       │   ├── Color+Hex.swift         # Hex color conversion
│       │   └── CGPoint+Extensions.swift # CGPoint utilities
│       └── Constants.swift             # App constants
├── Resources/
│   ├── Assets.xcassets/                # App icons and images
│   ├── Info.plist                     # App configuration
│   └── myMindMap.entitlements         # App sandbox entitlements
├── project.yml                         # XcodeGen configuration
└── README.md                           # Project documentation
```

---

## 10. Dependencies

### Native Frameworks (No External Dependencies)

| Framework | Purpose |
|-----------|---------|
| SwiftUI | UI Framework |
| SwiftData | Persistence |
| Foundation | Core utilities |
| AppKit | macOS integration |
| UniformTypeIdentifiers | File types for export |

### No External Dependencies Required

The MVP uses only native Apple frameworks, ensuring:
- Faster builds
- Smaller app size
- No dependency management complexity
- Maximum compatibility

---

## 11. Accessibility

- **VoiceOver**: Full support via SwiftUI's built-in accessibility
- **Keyboard Navigation**: All features accessible via keyboard
- **High Contrast**: Respects system accessibility settings
- **Dynamic Type**: Node text respects system font size preferences

---

## 12. API Reference

This section documents the public interfaces for the main ViewModels and services.

### 12.1 MindMapViewModel

Manages the overall mind map document lifecycle.

```swift
@Observable
class MindMapViewModel {
    // Properties
    var currentMindMap: MindMap?
    var recentMindMaps: [MindMap]
    var isDirty: Bool

    // Methods
    func setModelContext(_ context: ModelContext)
    func createNewMindMap()
    func saveMindMap()
    func loadRecentMindMaps()
    func openMindMap(_ mindMap: MindMap)
    func deleteMindMap(_ mindMap: MindMap)
}
```

### 12.2 CanvasViewModel

Manages canvas state, pan/zoom, and viewport calculations.

```swift
@Observable
class CanvasViewModel {
    // Viewport state
    var scale: CGFloat = 1.0
    var offset: CGPoint = .zero

    // Selection state
    var selectedNodeIDs: Set<UUID>
    var focusedNodeID: UUID?

    // Methods
    func zoomIn()
    func zoomOut()
    func fitToScreen()
    func pan(by delta: CGPoint)
    func nodeAt(point: CGPoint) -> MindMapNode?
}
```

### 12.3 NodeViewModel

Manages node editing and manipulation.

```swift
@Observable
class NodeViewModel {
    // Node state
    var editingNodeID: UUID?
    var editText: String

    // Methods
    func addChildNode(to nodeID: UUID) -> MindMapNode?
    func addSiblingNode(to nodeID: UUID) -> MindMapNode?
    func deleteNode(id: UUID)
    func duplicateNode(id: UUID) -> MindMapNode?
    func moveNode(id: UUID, to position: CGPoint)
    func collapseNode(id: UUID)
    func expandNode(id: UUID)
}
```

### 12.4 KeyboardViewModel

Handles keyboard shortcut processing and command routing.

```swift
@Observable
class KeyboardViewModel {
    // Properties
    var isCommandMode: Bool
    var lastKeyPress: KeyEquivalent?

    // Methods
    func handleKeyPress(_ key: KeyEquivalent, modifiers: EventModifiers) -> Bool
}
```

### 12.5 SwiftData Models

#### MindMap

```swift
@Model
class MindMap {
    var id: UUID
    var title: String
    var createdAt: Date
    var modifiedAt: Date

    var nodes: [MindMapNode]
    var connections: [NodeConnection]

    func markModified()
}
```

#### MindMapNode

```swift
@Model
final class MindMapNode {
    var id: UUID
    var text: String
    var positionX: Double
    var positionY: Double
    var width: Double
    var height: Double
    var backgroundColorHex: String
    var textColorHex: String
    var fontSize: Double
    var isCollapsed: Bool
    var createdAt: Date

    var parent: MindMapNode?
    var children: [MindMapNode]
    var outgoingConnections: [NodeConnection]
    var incomingConnections: [NodeConnection]
    var mindMap: MindMap?

    // Computed properties
    var position: CGPoint
    var frame: CGRect
}
```

#### NodeConnection

```swift
@Model
final class NodeConnection {
    var id: UUID
    var styleRawValue: String
    var colorHex: String
    var createdAt: Date

    var sourceNode: MindMapNode?
    var targetNode: MindMapNode?
    var mindMap: MindMap?

    var style: ConnectionStyle
}
```

### 12.6 Enums

#### ConnectionStyle

```swift
enum ConnectionStyle: String, Codable, CaseIterable {
    case straight
    case curved
    case bezier

    var displayName: String
}
```

---

*Document Version: 1.0*
*Last Updated: 2026-03-10*
