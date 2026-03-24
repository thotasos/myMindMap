# myMindMap Architecture

**Version:** 1.0.0
**Last Updated:** 2026-03-23
**macOS Version Support:** macOS 14.0+ (Sonoma and later)

---

## Section 1: System Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                    NSDocument Layer                                  │
│  ┌────────────────────────────────────────────────────────────────────────────────┐ │
│  │                     MindMapDocument (NSDocument)                                │ │
│  │  - Manages file I/O (.mindmap bundled directory)                                 │ │
│  │  - Auto-backup via Timer.publish (every 30s or on change)                       │ │
│  │  - Corruption recovery UI via NSError Recovery Attempting                       │ │
│  │  - changeCount tracking for dirty state                                         │ │
│  └────────────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────────────┘
                                          │
                                          ▼
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                   MainActor Layer                                    │
│  ┌────────────────────────────────────────────────────────────────────────────────┐ │
│  │              MindMapViewModel (@Observable, @MainActor, actor)                   │ │
│  │  - selectedNodeId: UUID?                                                        │ │
│  │  - expandedNodeIds: Set<UUID>                                                 │ │
│  │  - canvasOffset: CGPoint                                                      │ │
│  │  - canvasZoom: CGFloat (0.1...4.0)                                            │ │
│  │  - isFullscreen: Bool                                                         │ │
│  │  - isShortcutsOverlayVisible: Bool                                            │ │
│  │  - searchQuery: String                                                        │ │
│  │  - navigationHistory: [UUID] (Cmd+[/] navigation)                              │ │
│  │  - autoSaveTimer: Timer.publish                                               │ │
│  └────────────────────────────────────────────────────────────────────────────────┘ │
│                                          │                                          │
│                    ┌─────────────────────┼─────────────────────┐                   │
│                    ▼                     ▼                     ▼                   │
│     ┌─────────────────────────┐  ┌─────────────────────────┐  ┌─────────────────┐  │
│     │  SwiftData ModelContext │  │   MindMapRepository     │  │  Theme System   │  │
│     │  (@MainActor only)      │  │   (Protocol + Impl)     │  │  (Dark/Light)   │  │
│     │  - MindMap              │  │   - save()             │  │  - 300ms anim   │  │
│     │  - MindMapNode          │  │   - load()             │  │  - Dynamic colors│  │
│     │  - MindMapConnection    │  │   - queryByViewport()  │  │                 │  │
│     └─────────────────────────┘  └─────────────────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────────┘
                                          │
                                          ▼
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                    SwiftUI View Layer                                │
│  ┌────────────────────────────────────────────────────────────────────────────────┐ │
│  │                           CanvasView (Root)                                   │ │
│  │  - Fullscreen distraction-free mode                                            │ │
│  │  - Keyboard event handling (arrow nav, Cmd+N, Cmd+?)                           │ │
│  │  - Gesture handling (pan, pinch zoom)                                         │ │
│  │  - Auto-zoom to fit (50pt padding, 300ms ease-in-out)                         │ │
│  └────────────────────────────────────────────────────────────────────────────────┘ │
│                    │                                 │                              │
│                    ▼                                 ▼                              │
│     ┌─────────────────────────┐        ┌─────────────────────────┐               │
│     │  ConnectionsLayerView   │        │     NodesLayerView      │               │
│     │  - Bezier paths         │        │  - Viewport culling     │               │
│     │  - 1.5pt stroke         │        │  - R-tree spatial index │               │
│     │  - 8 HSB hue colors     │        │  - ForEach/idempotent   │               │
│     └─────────────────────────┘        └─────────────────────────┘               │
│                                                 │                                   │
│                                                 ▼                                   │
│                                      ┌─────────────────────┐                        │
│                                      │     NodeView        │                        │
│                                      │  - Auto-size font   │                        │
│                                      │    (24pt→12pt)      │                        │
│                                      │  - Rounded rect     │                        │
│                                      │    (8pt radius)     │                        │
│                                      │  - Notes: 2 lines   │                        │
│                                      │    10pt SF Pro Italic│                       │
│                                      └─────────────────────┘                        │
└─────────────────────────────────────────────────────────────────────────────────────┘
                                          │
                                          ▼
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                   Overlay Layer                                     │
│  ┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────────┐  │
│  │KeyboardShortcuts     │  │   SearchOverlayView  │  │    StatusBarView        │  │
│  │OverlayView           │  │   (Cmd+F)            │  │    - Node count         │  │
│  │(Cmd+?)               │  │   - Real-time filter │  │    - Zoom level         │  │
│  │- Floating panel     │  │   - Highlight match  │  │    - Save status        │  │
│  └──────────────────────┘  └──────────────────────┘  └──────────────────────────┘  │
│                                                                                     │
│  ┌────────────────────────────────────────────────────────────────────────────────┐ │
│  │                           ToolbarView (Floating)                               │ │
│  │  - Add child node (Cmd+N)                                                      │ │
│  │  - Delete node (Delete)                                                       │ │
│  │  - Toggle expand (Cmd+E)                                                      │ │
│  │  - Zoom controls (+/-)                                                        │ │
│  │  - Fit to screen (Cmd+0)                                                      │ │
│  └────────────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Section 2: Component Breakdown

### MindMapDocument (NSDocument Subclass)

| Aspect | Detail |
|--------|--------|
| **File Type** | `.mindmap` (bundled directory) |
| **Bundle Contents** | SwiftData store + metadata.json + resources/ |
| **Auto-Backup** | Timer.publish every 30s when dirty, stored in `.backup/` |
| **Corruption Recovery** | NSError Recovery Attempting with "Recover from Backup" option |
| **Security** | App Sandbox + NSFileProtectionComplete |
| **Bookmarks** | Security-Scoped Bookmarks for file access persistence |
| **Key Methods** | `read(from:ofType:)`, `write(to:ofType:)`, `fileWrapper()` |

### MindMapViewModel (@Observable, @MainActor, actor-isolated)

| Aspect | Detail |
|--------|--------|
| **Isolation** | @MainActor - all SwiftData ops on main thread |
| **Auto-Save** | Timer.publish (30s interval) via MainActor.assumeIsolated |
| **History** | navigationHistory stack, Cmd+[/] navigation |
| **Debounce** | Cmd+N debounced 500ms |
| **State** | selectedNodeId, expandedNodeIds, canvasOffset, canvasZoom |
| **Validation** | Node text max 10,000 chars, input sanitization for exports |

### CanvasView (Root SwiftUI View)

| Aspect | Detail |
|--------|--------|
| **Role** | Root view, handles all keyboard input |
| **Focus** | FocusState for keyboard navigation |
| **Gestures** | DragGesture (pan), MagnificationGesture (zoom) |
| **Viewport** | Culling via GeometryReader, passes visible rect to layers |
| **Animation** | 300ms ease-in-out for zoom transitions |

### NodeView (Individual Node Rendering)

| Aspect | Detail |
|--------|--------|
| **Container** | RoundedRectangle, 8pt corner radius |
| **Title Font** | depth-based: 24pt (depth 0) → 12pt (depth 12+) |
| **Notes** | 2 lines visible, 10pt SF Pro Italic, max 10,000 chars |
| **Selection** | Blue border ring on selection |
| **Expand/Collapse** | Chevron icon for nodes with children |
| **TextField** | onCommit triggers ViewModel.updateTitle() |

### NodesLayerView (Viewport Culling Layer)

| Aspect | Detail |
|--------|--------|
| **Spatial Index** | R-tree (R*tree or RBush) for O(log n) viewport queries |
| **Culling** | Only renders nodes intersecting visible rect + margin |
| **Performance Target** | 60fps at 10,000 nodes |
| **Lazy Build** | R-tree built on background thread, accessed on main |
| **Implementation** | ForEach with explicit id, keyed by node.id |

### ConnectionsLayerView (Bezier Connectors)

| Aspect | Detail |
|--------|--------|
| **Path Type** | Bezier curves (cubic) from parent center to child center |
| **Stroke** | 1.5pt, 8 HSB hue colors distributed by depth |
| **Culling** | Only paths where either endpoint visible |
| **Style** | Colorful thin connectors, anti-aliased |

### KeyboardShortcutsOverlayView (Floating Panel)

| Aspect | Detail |
|--------|--------|
| **Trigger** | Cmd+? (also Esc to dismiss) |
| **Position** | Centered floating panel, 400x300pt |
| **Content** | Shortcut reference table |
| **Style** | NSVisualEffectView with .hudWindow material |

### Theme (Dark/Light Mode System)

| Aspect | Detail |
|--------|--------|
| **Default** | Dark mode |
| **Transition** | 300ms animated (NSAnimationContext) |
| **Colors** | Dynamic system colors (Color.accentColor, etc.) |
| **Override** | User can force light/dark via Appearance settings |

### MindMapRepository (Protocol + SwiftData Implementation)

| Aspect | Detail |
|--------|--------|
| **Protocol** | `save()`, `load()`, `queryByViewport(rect:)` |
| **SwiftData** | ModelContext-based, @MainActor |
| **Spatial Query** | R-tree backed viewport queries |
| **Swapability** | Can replace with SQLite.swift without changing ViewModel |

---

## Section 3: Data Flow

### Node Edit Flow

```
1. USER INPUT
   └─> User types in NodeView.textField, presses Return
       │
2. CANVAS VIEW CHECK
   └─> CanvasView monitors focus via FocusState
       │
3. NODE VIEW COMMIT
   └─> NodeView.textField.onCommit fires
       └─> NodeViewModel.updateTitle(newTitle)
           │
4. VIEWMODEL PROCESSING (@MainActor)
   └─> Validates text (max 10,000 chars)
   └─> Updates MindMapNode.title in ModelContext
   └─> Sets document.needsBackup = true
   └─> Triggers auto-save timer reset
       │
5. AUTO-SAVE TIMER (MainActor.assumeIsolated)
   └─> Timer.publish fires on main runloop
       └─> Task { @MainActor in
               try? ModelContext.save()
               MindMapDocument.updateChangeCount()
             }
       │
6. DOCUMENT SYNC
   └─> NSDocument detects change count increment
       └─> File coordinator writes to .mindmap bundle
```

### Keyboard Navigation Flow

```
1. CanvasView receives keyDown via View.onKeyDown
   │
2. Arrow Keys → Navigate selectedNodeId
   └─> Find adjacent node in tree structure
   └─> Update navigationHistory
   │
3. Cmd+[ → Navigate back in history
   └─> Pop from navigationHistory stack
   └─> Set selectedNodeId to previous
   │
4. Cmd+] → Navigate forward
   └─> (Future: redo stack)
```

### Search Flow

```
1. Cmd+F toggles SearchOverlayView
   │
2. User types query
   └─> searchQuery updates in MindMapViewModel
   └─> NodesLayerView filters: node.title.localizedContains(query)
       │
3. Matching nodes highlighted
   │
4. Enter selects next match
   └─> Updates selectedNodeId
```

---

## Section 4: State Management

### MindMapViewModel (@Observable, @MainActor)

```swift
@Observable
@MainActor
final class MindMapViewModel {

    // Selection State
    var selectedNodeId: UUID?
    var expandedNodeIds: Set<UUID> = []

    // Canvas State
    var canvasOffset: CGPoint = .zero
    var canvasZoom: CGFloat = 1.0  // 0.1...4.0 range

    // UI State
    var isFullscreen: Bool = false
    var isShortcutsOverlayVisible: Bool = false
    var isSearchOverlayVisible: Bool = false
    var searchQuery: String = ""

    // Navigation
    var navigationHistory: [UUID] = []
    var historyIndex: Int = -1

    // Document Reference
    var document: MindMapDocument?
    var modelContext: ModelContext?

    // Auto-Save
    private var autoSaveTimer: Timer?
    private var needsSave: Bool = false
}
```

### State Transition Rules

| Action | State Change |
|--------|--------------|
| Click node | selectedNodeId = clicked.id |
| Cmd+E | Toggle node.id in expandedNodeIds |
| Cmd+N | Create child of selected, add to expandedNodeIds |
| Delete | Remove selected from parent, cascade delete children |
| Cmd+0 | canvasZoom = fitToContent(), animate 300ms |
| Cmd+? | isShortcutsOverlayVisible.toggle() |
| Cmd+F | isSearchOverlayVisible.toggle() |
| Focus change | Updates via @Environment(\.colorScheme) observation |

### Auto-Save Mechanism

```swift
// Timer.publish runs on main runloop
autoSaveTimer = Timer.publish(every: 30, on: .main, in: .common)
    .autoconnect()
    .sink { [weak self] _ in
        Task { @MainActor [weak self] in
            guard let self, self.needsSave else { return }
            try? self.modelContext?.save()
            self.document?.updateChangeCount()
            self.needsSave = false
        }
    }

// Timer callback requires MainActor.assumeIsolated for safety
MainActor.assumeIsolated {
    autoSaveTimer?.sink { ... }
}
```

---

## Section 5: Storage Schema

### SwiftData Entities

```swift
@Model
final class MindMap {
    @Attribute(.unique) var id: UUID
    var title: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \MindMapNode.mindMap)
    var nodes: [MindMapNode]

    @Relationship(deleteRule: .cascade, inverse: \MindMapConnection.mindMap)
    var connections: [MindMapConnection]

    init(
        id: UUID = UUID(),
        title: String = "Untitled Mind Map",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.nodes = []
        self.connections = []
    }
}

@Model
final class MindMapNode {
    @Attribute(.unique) var id: UUID
    var title: String
    var notes: String  // max 10,000 chars
    var position: CGPoint
    var depth: Int
    var isExpanded: Bool
    var parentId: UUID?
    var color: String  // hex format

    var mindMap: MindMap?

    // Computed for layout
    var children: [MindMapNode] {
        mindMap?.nodes.filter { $0.parentId == self.id } ?? []
    }

    init(
        id: UUID = UUID(),
        title: String = "",
        notes: String = "",
        position: CGPoint = .zero,
        depth: Int = 0,
        isExpanded: Bool = true,
        parentId: UUID? = nil,
        color: String = "#4A90D9"
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.position = position
        self.depth = depth
        self.isExpanded = isExpanded
        self.parentId = parentId
        self.color = color
    }
}

@Model
final class MindMapConnection {
    @Attribute(.unique) var id: UUID
    var sourceNodeId: UUID
    var targetNodeId: UUID
    var color: String  // hex format

    var mindMap: MindMap?

    init(
        id: UUID = UUID(),
        sourceNodeId: UUID,
        targetNodeId: UUID,
        color: String = "#4A90D9"
    ) {
        self.id = id
        self.sourceNodeId = sourceNodeId
        self.targetNodeId = targetNodeId
        self.color = color
    }
}
```

### File Format: .mindmap Bundle

```
MyMap.mindmap/
├── metadata.json          # Version, createdAt, mindMapId
├── store/
│   └── default.store      # SwiftData SQLite store
└── resources/
    └── (future: embedded images, etc.)
```

### Backup Format

```
MyMap.mindmap.backup/
├── backup_YYYYMMDD_HHmmss/
│   ├── metadata.json
│   └── store/
│       └── default.store
└── latest -> backup_YYYYMMDD_HHmmss/  # symlink
```

---

## Section 6: Async/Concurrency Model

### Threading Strategy

| Operation | Thread/Actor | Notes |
|-----------|--------------|-------|
| SwiftData access | @MainActor only | ModelContext is main-actor isolated |
| UI updates | @MainActor | All SwiftUI views |
| File I/O | NSDocument background | Via NSFileCoordinator |
| R-tree build | Background thread | Task { } with .background QoS |
| R-tree query | Main thread | After async build completes |
| Auto-save | MainActor.assumeIsolated | Timer callbacks cross actor boundary |

### R-tree Spatial Index

```swift
actor SpatialIndex {
    private var tree: RBush<IndexedNode>
    private var isBuilt: Bool = false

    // Built lazily on background thread
    func build(nodes: [MindMapNode]) async {
        let indexed = nodes.map { IndexedNode(node: $0) }
        tree = RBush(entries: indexed)
        tree.build()
        isBuilt = true
    }

    // O(log n) viewport query, called on main thread
    func queryViewport(_ rect: CGRect) -> [UUID] {
        guard isBuilt else { return [] }
        return tree.search(rect).map { $0.id }
    }
}

// Usage in NodesLayerView
@State private var spatialIndex = SpatialIndex()
let visibleNodeIds: [UUID] = await spatialIndex.queryViewport(visibleRect)
```

### Auto-Save Concurrency

```swift
// Timer.publish delivers to main runloop
// We need MainActor.assumeIsolated to call @MainActor methods
MainActor.assumeIsolated {
    autoSaveTimer = Timer.publish(every: 30, on: .main, in: .common)
        .autoconnect()
        .sink { [weak self] _ in
            Task { @MainActor [weak self] in
                try? self?.modelContext?.save()
                self?.document?.updateChangeCount()
            }
        }
}
```

---

## Section 7: Error Handling Strategy

### Error Types

| Error Type | Handling Strategy |
|------------|-------------------|
| SwiftData save failure | Show alert with "Retry" / "Discard Changes" options |
| File I/O read failure | Attempt backup restore, show "Recovered from Backup" alert |
| File I/O write failure | Keep in-memory, retry on next auto-save, warn user |
| Corruption detected | Offer to restore from .backup directory |
| Memory pressure | Flush R-tree cache, rebuild on next viewport change |

### NSDocument Error Recovery

```swift
extension MindMapDocument {
    override func handleError(_ error: Error, userInteractionMethod: NSUserInteractionMethod) async -> Bool {
        guard let documentError = error as? DocumentError else {
            return await super.handleError(error, userInteractionMethod: userInteractionMethod)
        }

        switch documentError {
        case .fileCorrupted:
            return await try await presentRecoveryError(
                documentError,
                options: [
                    "Restore from Backup": restoreFromBackup,
                    "Create New Document": createNewDocument
                ],
                recoveryDelegate: self,
                userInteractionMethod: userInteractionMethod
            )

        case .saveFailed:
            return await try await presentRecoveryError(
                documentError,
                options: [
                    "Retry": { [weak self] in try await self?.saveToURL() },
                    "Choose Different Location": { [weak self] in self?.saveToNewLocation() }
                ],
                recoveryDelegate: self,
                userInteractionMethod: userInteractionMethod
            )
        }
    }
}
```

### Auto-Backup Implementation

```swift
func performBackup() throws {
    let backupDir = containerURL.appendingPathComponent(".backup")
    try FileManager.default.createDirectory(at: backupDir, withIntermediateDirectories: true)

    let timestamp = ISO8601DateFormatter().string(from: Date())
        .replacingOccurrences(of: ":", with: "-")

    let backupVersion = backupDir.appendingPathComponent("backup_\(timestamp)")

    // Copy current to backup (atomic if possible)
    let coordinator = NSFileCoordinator()
    var coordinatorError: NSError?

    coordinator.coordinate(writingItemAt: fileURL, options: .forReplacing, error: &coordinatorError) { url in
        try? FileManager.default.copyItem(at: url, to: backupVersion)
    }

    if let error = coordinatorError {
        throw error
    }

    // Prune old backups (keep last 10)
    pruneOldBackups(keeping: 10)
}
```

### Corruption Recovery UI

```
┌─────────────────────────────────────────────────────────────┐
│  ⚠️  Document Recovery                                      │
│                                                              │
│  The document "MyMap.mindmap" could not be opened           │
│  because it appears to be corrupted.                        │
│                                                              │
│  [ ] Restore from most recent backup (Recommended)          │
│      "MyMap.mindmap.backup/backup_20260323_143052/"         │
│                                                              │
│  [ ] Create a new empty document                            │
│                                                              │
│                    [Cancel]  [Restore]                       │
└─────────────────────────────────────────────────────────────┘
```

---

## Section 8: Extension Points

### Export Formats

| Format | Module | Implementation |
|--------|--------|----------------|
| JSON | MindMapExportJSON | Codable export with full fidelity |
| Markdown | MindMapExportMarkdown | Hierarchical outline format |
| PNG | MindMapExportPNG | Canvas snapshot via view.render() |

```swift
protocol MindMapExportable {
    func export(mindMap: MindMap, to url: URL) async throws
}

final class MindMapExportJSON: MindMapExportable {
    func export(mindMap: MindMap, to url: URL) async throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(mindMap)
        try data.write(to: url)
    }
}

final class MindMapExportMarkdown: MindMapExportable {
    func export(mindMap: MindMap, to url: URL) async throws {
        let text = renderMarkdown(mindMap.rootNode)
        try text.write(to: url, atomically: true, encoding: .utf8)
    }
}

final class MindMapExportPNG: MindMapExportable {
    func export(mindMap: MindMap, to url: URL) async throws {
        let renderer = ImageRenderer(content: CanvasView(viewModel: viewModel))
        renderer.render { image, error in
            guard let cgImage = image?.cgImage else { throw error }
            try? NSBitmapImageRep(cgImage: cgImage).representation(.png)?.write(to: url)
        }
    }
}
```

### Repository Pattern

The `MindMapRepository` protocol allows swapping SwiftData for alternative backends:

```swift
protocol MindMapRepository: AnyObject {
    @MainActor func save(_ mindMap: MindMap) async throws
    @MainActor func load(id: UUID) async throws -> MindMap
    @MainActor func queryViewport(_ rect: CGRect) async throws -> [MindMapNode]
    @MainActor func delete(_ mindMap: MindMap) async throws
}

// SwiftData Implementation
final class SwiftDataMindMapRepository: MindMapRepository {
    private let modelContext: ModelContext

    @MainActor func save(_ mindMap: MindMap) async throws {
        modelContext.insert(mindMap)
        try modelContext.save()
    }
}

// SQLite.swift Alternative (future)
final class SQLiteMindMapRepository: MindMapRepository {
    private let database: Connection

    @MainActor func save(_ mindMap: MindMap) async throws {
        // SQLite.swift insert/replace
    }
}
```

### Theme System

```swift
struct Theme {
    let nodeBackground: Color
    let nodeBorder: Color
    let nodeTitle: Color
    let nodeNotes: Color
    let connectorColors: [Color]  // 8 HSB hues

    static let dark = Theme(
        nodeBackground: Color(hex: "#2D2D2D"),
        nodeBorder: Color(hex: "#4A4A4A"),
        nodeTitle: .white,
        nodeNotes: Color(hex: "#AAAAAA"),
        connectorColors: [
            Color(hue: 0.0, saturation: 0.7, brightness: 0.9),   // Red
            Color(hue: 0.1, saturation: 0.7, brightness: 0.9),   // Orange
            Color(hue: 0.2, saturation: 0.7, brightness: 0.9),   // Yellow
            Color(hue: 0.3, saturation: 0.7, brightness: 0.9),  // Green
            Color(hue: 0.5, saturation: 0.7, brightness: 0.9),   // Blue
            Color(hue: 0.6, saturation: 0.7, brightness: 0.9),  // Purple
            Color(hue: 0.7, saturation: 0.7, brightness: 0.9),  // Pink
            Color(hue: 0.8, saturation: 0.7, brightness: 0.9),   // Cyan
        ]
    )

    static let light = Theme(
        nodeBackground: .white,
        nodeBorder: Color(hex: "#CCCCCC"),
        nodeTitle: .black,
        nodeNotes: Color(hex: "#666666"),
        connectorColors: dark.connectorColors  // Same hues, adjusted brightness
    )
}
```

### Custom Color Palettes

```swift
extension Theme {
    static let palettes: [String: Theme] = [
        "default": .dark,
        "monochrome": monochromePalette,
        "pastel": pastelPalette,
        "vibrant": vibrantPalette
    ]
}
```

---

## Appendix: Constraints Compliance Matrix

| Constraint | Implementation | Section |
|------------|---------------|---------|
| HARD: Atomic file I/O + auto-backup | NSFileCoordinator + Timer.publish backup | §1, §7 |
| HARD: Viewport culling, 60fps @ 10k nodes | R-tree spatial index, O(log n) queries | §2, §5 |
| HARD: App Sandbox + NSFileProtectionComplete | NSDocument + Security-Scoped Bookmarks | §1, §7 |
| HARD: @MainActor for SwiftData | @MainActor MindMapViewModel, ModelContext main-only | §3, §4 |
| SOFT: Auto dark mode, 300ms transition | NSAnimationContext, @Environment colorScheme | §2, §4 |
| SOFT: Debounce Cmd+N 500ms | Task debounce in MindMapViewModel | §3, §4 |
| SOFT: Node text max 10,000 chars | Validation in NodeViewModel.updateTitle() | §3, §4 |
| SOFT: Input sanitization for exports | MindMapExportable protocol sanitizes | §8 |

---

*Document generated for myMindMap v1.0.0*
