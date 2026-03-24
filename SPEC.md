# myMindMap Specification Document
**Version:** 1.0.0
**Created:** 2026-03-23
**Project:** myMindMap - Minimalist Mind Map macOS Desktop App

---

## SECTION 1: Feature Inventory

| F-N | Feature | Description | Acceptance Criterion | Test Function |
|-----|---------|-------------|---------------------|---------------|
| F-01 | New Document | Create new mind map with central "Untitled" node | Central node appears at center (0,0), title "Untitled", selected=true, depth=0 | `testNewDocument_CentralNodeSelected()` |
| F-02 | Open Document | Open existing .mindmap file, restore state | Central node selected on open, all nodes/connections restored | `testOpenDocument_RestoresState()` |
| F-03 | Save Document | Save current state to .mindmap file with auto-backup | File saved to ~/Documents/myMindMap/, backup created at `filename.backup.timestamp`, no corruption | `testSaveDocument_WithBackup()` |
| F-04 | Save As | Save document to user-specified location | Prompts NSSavePanel, creates new file | `testSaveAs_CreatesNewFile()` |
| F-05 | Node Selection | Select node with click, shows 2pt blue ring | Selected node has 2pt #007AFF ring, 300ms ease-out animation | `testNodeSelection_BlueRing()` |
| F-06 | Node Navigation | Arrow keys navigate between nodes | Up/Down/Left/Right selects adjacent node in star layout | `testArrowKeyNavigation()` |
| F-07 | Node Editing | Enter key enters edit mode on selected node | Title text becomes editable TextField, cursor active | `testNodeEditing_EnterKey()` |
| F-08 | Node Title Edit | Edit node title text | Title updates in real-time, max 10,000 chars | `testNodeTitle_10kCharLimit()` |
| F-09 | Node Notes Edit | Edit node notes (2 lines visible) | Notes field 10pt SF Pro Italic, scrollable after 2 lines | `testNodeNotes_2LineVisible()` |
| F-10 | Node Expand/Collapse | Space toggles expand/collapse | Children hidden when collapsed, animated 250ms ease-in-out | `testNodeExpandCollapse()` |
| F-11 | Collapse All | Cmd+Shift+C collapses all nodes | All non-root nodes hidden, parent shows collapsed indicator | `testCollapseAll()` |
| F-12 | Expand All | Cmd+Shift+E expands all nodes | All nodes visible, no collapsed indicators | `testExpandAll()` |
| F-13 | Add Child Node | Tab or Cmd+Return adds child to selected node | New node appears at calculated radial position, depth+1 | `testAddChildNode()` |
| F-14 | Delete Node | Cmd+Backspace deletes selected node | Node and all descendants removed, connections severed | `testDeleteNode()` |
| F-15 | Duplicate Node | Cmd+D duplicates selected node | Copy appears offset 20pt right, same depth | `testDuplicateNode()` |
| F-16 | Copy/Cut/Paste | Cmd+C/X/V for clipboard operations | Node copied with connections, pasted as new subtree | `testClipboardOperations()` |
| F-17 | Navigate Back | Cmd+[ navigates to previous node | Selection moves to previously selected node | `testNavigateBack()` |
| F-18 | Navigate Forward | Cmd+] navigates to next node | Selection moves to next in history stack | `testNavigateForward()` |
| F-19 | Zoom to 100% | Cmd+1 sets zoom to 100% | View scales to actual size, centered | `testZoomTo100Percent()` |
| F-20 | Reset View | Cmd+0 resets zoom and pan to default | Zoom=1.0, pan=(0,0), central node visible | `testResetView()` |
| F-21 | Auto-Fit View | Auto-zoom on add node to fit screen | Zooms to show all nodes with 50pt padding | `testAutoFitView()` |
| F-22 | Search Nodes | Cmd+F opens search overlay | SearchField focuses, filters nodes by title/notes | `testSearchNodes()` |
| F-23 | Keyboard Shortcuts Window | Cmd+? or F1 shows floating window | Window lists all shortcuts, dismissible with Escape | `testShortcutsWindow()` |
| F-24 | Fullscreen Mode | Toggle with Ctrl+Cmd+F or menu | Distraction-free mode, toolbar hidden | `testFullscreenMode()` |
| F-25 | Dark Mode | Auto-follows macOS appearance | 300ms animated transition between modes | `testDarkModeTransition()` |
| F-26 | Light Mode | Manual override available | User can force light mode in View menu | `testLightModeOverride()` |
| F-27 | Node Font Sizing | Font scales by depth | depth 0=24pt, depth 1=18pt, depth 2=14pt, depth 3+=12pt min | `testNodeFontScaling()` |
| F-28 | Node Rounded Rectangles | All nodes in rounded rectangles | 8pt corner radius, fill color per node | `testNodeRoundedRectangles()` |
| F-29 | Node Connectors | Colorful thin lines between nodes | 1.5pt stroke, 8 distinct HSB hues at 100% sat, 70% brightness | `testNodeConnectors()` |
| F-30 | Viewport Culling | Only visible nodes rendered | 60fps with 10k nodes, spatial index O(log n) query | `testViewportCulling_10kNodes()` |
| F-31 | Node Text Max Length | Title capped at 10,000 characters | Input rejected beyond limit, no truncation | `testNodeTextMaxLength()` |
| F-32 | HTML Sanitization | Notes sanitized before export | HTML tags stripped, only plain text exported | `testHTMLSanitization()` |
| F-33 | Auto Backup | Automatic backup before save | Backup at `filename.mindmap.backup.timestamp` created | `testAutoBackup()` |
| F-34 | Corruption Recovery | Detect and recover from corruption | Recovery UI shown if file corrupted, offer restore from backup | `testCorruptionRecovery()` |
| F-35 | Select All | Cmd+A selects all nodes | All nodes highlighted, batch operations available | `testSelectAll()` |
| F-36 | Cancel Edit | Escape cancels current edit | Reverts to pre-edit state | `testCancelEdit()` |
| F-37 | Exit Fullscreen | Escape exits fullscreen mode | Returns to normal view | `testExitFullscreen()` |
| F-38 | Star/Radial Layout | All nodes in radial layout | No horizontal/vertical/tree layouts available | `testRadialLayoutOnly()` |
| F-39 | App Sandbox | App Sandbox enabled | Hardened Runtime, sandbox enabled in entitlements | `testAppSandboxEnabled()` |
| F-40 | File Permissions | 700 directory permissions | `~/Documents/myMindMap/` created with 700 permissions | `testFilePermissions()` |
| F-41 | SwiftData @MainActor | All SwiftData ops on main actor | Compilation enforced, no actor isolation errors | `testMainActorIsolation()` |
| F-42 | Rapid Action Coalescing | Cmd+N debounced 500ms | Rapid Cmd+N calls coalesced, single document created | `testRapidActionCoalescing()` |

---

## SECTION 2: Keyboard Shortcuts Table

| Action | Shortcut | Category | Description |
|--------|----------|----------|-------------|
| New Document | Cmd+N | File | Create new mind map with central "Untitled" node |
| Open Document | Cmd+O | File | Open existing .mindmap file |
| Save | Cmd+S | File | Save current document with auto-backup |
| Save As | Cmd+Shift+S | File | Save document to user-specified location |
| Close Window | Cmd+W | File | Close current window |
| Undo | Cmd+Z | Edit | Undo last action |
| Redo | Cmd+Shift+Z | Edit | Redo last undone action |
| Cut | Cmd+X | Edit | Cut selected node(s) |
| Copy | Cmd+C | Edit | Copy selected node(s) |
| Paste | Cmd+V | Edit | Paste clipboard contents |
| Select All | Cmd+A | Edit | Select all nodes |
| Delete Node | Cmd+Backspace | Edit | Delete selected node |
| Duplicate Node | Cmd+D | Edit | Duplicate selected node |
| Navigate Back | Cmd+[ | Navigation | Go to previously selected node |
| Navigate Forward | Cmd+] | Navigation | Go to next selected node |
| Navigate Up | Up Arrow | Navigation | Select node above in radial layout |
| Navigate Down | Down Arrow | Navigation | Select node below in radial layout |
| Navigate Left | Left Arrow | Navigation | Select node to the left in radial layout |
| Navigate Right | Right Arrow | Navigation | Select node to the right in radial layout |
| Edit Node | Return/Enter | Node | Enter edit mode on selected node |
| Cancel Edit | Escape | Node | Cancel current edit, revert changes |
| Toggle Expand/Collapse | Space | Node | Toggle expand/collapse on selected node |
| Add Child Node | Tab | Node | Add new child to selected node |
| Add Sibling Node | Cmd+Return | Node | Add sibling after selected node |
| Collapse All | Cmd+Shift+C | Node | Collapse all nodes |
| Expand All | Cmd+Shift+E | Node | Expand all nodes |
| Search Nodes | Cmd+F | Search | Open search overlay |
| Close Search | Escape | Search | Close search overlay |
| Zoom to 100% | Cmd+1 | View | Set zoom to actual size |
| Zoom In | Cmd++ | View | Increase zoom by 25% |
| Zoom Out | Cmd+- | View | Decrease zoom by 25% |
| Reset View | Cmd+0 | View | Reset zoom and pan to default |
| Toggle Fullscreen | Ctrl+Cmd+F | View | Enter/exit distraction-free fullscreen |
| Show Shortcuts | Cmd+? or F1 | Help | Show floating keyboard shortcuts window |
| Close Shortcuts | Escape | Help | Close shortcuts window |

---

## SECTION 3: Requirements Traceability Matrix (RTM)

| REQ-N | Requirement | TC-N | Test Function | PASS |
|-------|-------------|------|---------------|------|
| REQ-01 | Central node "Untitled" on new document | TC-01 | `testNewDocument_CentralNodeSelected()` | [ ] |
| REQ-02 | Existing document opens with central node selected | TC-02 | `testOpenDocument_RestoresState()` | [ ] |
| REQ-03 | Arrow key node navigation | TC-03 | `testArrowKeyNavigation()` | [ ] |
| REQ-04 | Cmd+[ navigate back | TC-04 | `testNavigateBack()` | [ ] |
| REQ-05 | Cmd+] navigate forward | TC-05 | `testNavigateForward()` | [ ] |
| REQ-06 | Return/Enter edit selected node | TC-06 | `testNodeEditing_EnterKey()` | [ ] |
| REQ-07 | Escape cancel edit / exit fullscreen | TC-07 | `testCancelEdit()` / `testExitFullscreen()` | [ ] |
| REQ-08 | Cmd+? or F1 show shortcuts window | TC-08 | `testShortcutsWindow()` | [ ] |
| REQ-09 | Space toggle expand/collapse | TC-09 | `testNodeExpandCollapse()` | [ ] |
| REQ-10 | Cmd+Shift+C collapse all | TC-10 | `testCollapseAll()` | [ ] |
| REQ-11 | Cmd+Shift+E expand all | TC-11 | `testExpandAll()` | [ ] |
| REQ-12 | Cmd+1 zoom to 100% | TC-12 | `testZoomTo100Percent()` | [ ] |
| REQ-13 | Cmd+0 reset view | TC-13 | `testResetView()` | [ ] |
| REQ-14 | Cmd+A select all | TC-14 | `testSelectAll()` | [ ] |
| REQ-15 | Cmd+C/X/V copy/cut/paste | TC-15 | `testClipboardOperations()` | [ ] |
| REQ-16 | Cmd+F search nodes | TC-16 | `testSearchNodes()` | [ ] |
| REQ-17 | Cmd+Backspace delete node | TC-17 | `testDeleteNode()` | [ ] |
| REQ-18 | Cmd+D duplicate node | TC-18 | `testDuplicateNode()` | [ ] |
| REQ-19 | Fullscreen toggle | TC-19 | `testFullscreenMode()` | [ ] |
| REQ-20 | Cmd+N new document | TC-20 | `testNewDocument_CentralNodeSelected()` | [ ] |
| REQ-21 | Cmd+O open document | TC-21 | `testOpenDocument_RestoresState()` | [ ] |
| REQ-22 | Cmd+S save with auto-backup | TC-22 | `testSaveDocument_WithBackup()` | [ ] |
| REQ-23 | Cmd+Shift+S save as | TC-23 | `testSaveAs_CreatesNewFile()` | [ ] |
| REQ-24 | Auto-zoom to fit on add node | TC-24 | `testAutoFitView()` | [ ] |
| REQ-25 | Dark mode 300ms transition | TC-25 | `testDarkModeTransition()` | [ ] |
| REQ-26 | Light mode override available | TC-26 | `testLightModeOverride()` | [ ] |
| REQ-27 | Font depth 0=24pt, 1=18pt, 2=14pt, 3+=12pt | TC-27 | `testNodeFontScaling()` | [ ] |
| REQ-28 | Notes 10pt SF Pro Italic constant | TC-28 | `testNodeNotes_2LineVisible()` | [ ] |
| REQ-29 | Node 8pt rounded rectangles | TC-29 | `testNodeRoundedRectangles()` | [ ] |
| REQ-30 | Selected node 2pt #007AFF ring | TC-30 | `testNodeSelection_BlueRing()` | [ ] |
| REQ-31 | 8 distinct HSB hue connectors at 1.5pt | TC-31 | `testNodeConnectors()` | [ ] |
| REQ-32 | 50pt padding on auto-fit | TC-32 | `testAutoFitView()` | [ ] |
| REQ-33 | Viewport culling for 10k nodes at 60fps | TC-33 | `testViewportCulling_10kNodes()` | [ ] |
| REQ-34 | Spatial index O(log n) queries | TC-34 | `testViewportCulling_10kNodes()` | [ ] |
| REQ-35 | Node text max 10,000 chars | TC-35 | `testNodeTextMaxLength()` | [ ] |
| REQ-36 | HTML sanitized before export | TC-36 | `testHTMLSanitization()` | [ ] |
| REQ-37 | Atomic file I/O with auto-backup | TC-37 | `testAutoBackup()` | [ ] |
| REQ-38 | Corruption recovery UI | TC-38 | `testCorruptionRecovery()` | [ ] |
| REQ-39 | Cmd+N debounced 500ms | TC-39 | `testRapidActionCoalescing()` | [ ] |
| REQ-40 | App Sandbox + NSFileProtectionComplete | TC-40 | `testAppSandboxEnabled()` | [ ] |
| REQ-41 | 700 file permissions | TC-41 | `testFilePermissions()` | [ ] |
| REQ-42 | @MainActor isolation SwiftData | TC-42 | `testMainActorIsolation()` | [ ] |
| REQ-43 | Star/radial layout only | TC-43 | `testRadialLayoutOnly()` | [ ] |
| REQ-44 | Menu bar (File, Edit, View, Window, Help) | TC-44 | `testMenuBarExists()` | [ ] |
| REQ-45 | VoiceOver accessibility | TC-45 | `testVoiceOverAccessibility()` | [ ] |
| REQ-46 | Document-based (NSDocument) | TC-46 | `testDocumentBasedApp()` | [ ] |
| REQ-47 | Very high quality fonts | TC-47 | `testFontQuality()` | [ ] |
| REQ-48 | Distraction-free fullscreen | TC-48 | `testFullscreenMode()` | [ ] |

---

## SECTION 4: User Interactions & States

### 4.1 New Document State

**Entry:** User launches app or presses Cmd+N
**Initial Conditions:**
- No existing document open
- Central node created at position (0, 0)
- Title: "Untitled"
- Selected: true (central node)
- Expanded: true
- Depth: 0

**Visual Representation:**
```
┌─────────────────────┐
│  ●  Untitled        │  ← 24pt font, selected (blue ring)
│      ───────        │
│   (notes area)      │  ← 10pt SF Pro Italic
└─────────────────────┘
        │
   (radial children appear when added)
```

**Allowed Actions:**
- Type to edit title
- Arrow keys to navigate (no other nodes exist)
- Tab to add child
- Space to toggle (no children yet)
- Cmd+S to save

---

### 4.2 Open Document State

**Entry:** User presses Cmd+O, selects file
**Initial Conditions:**
- Mind map structure fully restored from file
- Central node selected
- All node states (expanded/collapsed) restored
- Viewport positioned to show central node

**Allowed Actions:**
- Any navigation or editing action
- All keyboard shortcuts active

---

### 4.3 Node Selected State

**Entry:** User clicks node or navigates with arrows
**Visual Indicators:**
- 2pt solid ring in #007AFF (blue)
- 300ms ease-out animation on selection

**Allowed Actions:**
- Arrow keys to navigate to adjacent nodes
- Space to toggle expand/collapse
- Enter to edit
- Cmd+D to duplicate
- Cmd+Backspace to delete
- Cmd+C/X/V for clipboard

---

### 4.4 Node Editing State

**Entry:** User presses Enter with node selected
**Visual Indicators:**
- Title text replaced with TextField
- Cursor blinking in TextField
- Notes area editable

**Allowed Actions:**
- Type to edit title (max 10,000 chars)
- Tab to move to notes field
- Enter to confirm (unless in notes)
- Escape to cancel and revert
- Cmd+Return to add sibling

**Exit Conditions:**
- Enter confirms and exits edit mode
- Escape cancels and exits edit mode
- Click outside node confirms and exits

---

### 4.5 Node Collapsed State

**Entry:** User presses Space on expanded node with children
**Visual Indicators:**
- Node shows collapsed indicator (dot or ellipsis)
- Children not rendered (viewport culled)
- Connection lines end at parent

**Allowed Actions:**
- Space to expand
- Click to select
- All navigation actions

---

### 4.6 Fullscreen Distraction-Free State

**Entry:** User presses Ctrl+Cmd+F
**Visual Changes:**
- Window fills entire screen
- Toolbar hidden
- Menu bar auto-hides
- Only mind map canvas visible

**Allowed Actions:**
- All navigation actions
- Escape to exit
- Limited to essential viewing/editing

**Exit Conditions:**
- Escape key
- Ctrl+Cmd+F toggle

---

### 4.7 Empty State

**Entry:** All nodes deleted except central
**Visual Representation:**
- Only central node visible
- Placeholder text in notes: "Add your first idea"

**Allowed Actions:**
- Tab to add child
- Type to edit title

---

### 4.8 Search Active State

**Entry:** User presses Cmd+F
**Visual Indicators:**
- Search overlay appears (top center)
- TextField focused
- Results highlight matching nodes

**Allowed Actions:**
- Type to filter
- Enter to select first result
- Arrow keys to navigate results
- Escape to close search
- Click result to select

**Exit Conditions:**
- Escape closes overlay
- Enter selects result
- Click outside closes

---

### 4.9 Shortcuts Overlay Visible State

**Entry:** User presses Cmd+? or F1
**Visual Indicators:**
- Floating window centered
- Semi-transparent background
- List of all keyboard shortcuts

**Allowed Actions:**
- Scroll if list long
- Escape to dismiss
- Click outside to dismiss

**Exit Conditions:**
- Escape key
- F1 or Cmd+? toggle off
- Click outside window

---

## SECTION 5: Data Model

### 5.1 MindMap Entity

```swift
import Foundation
import SwiftData

@Model
@MainActor
final class MindMap {
    /// Unique identifier for the mind map
    var id: UUID

    /// User-visible title of the mind map
    var title: String

    /// Timestamp when the mind map was first created
    var createdAt: Date

    /// Timestamp when the mind map was last modified
    var updatedAt: Date

    /// All nodes belonging to this mind map
    @Relationship(deleteRule: .cascade, inverse: \Node.mindMap)
    var nodes: [Node]

    /// All connections belonging to this mind map
    @Relationship(deleteRule: .cascade, inverse: \Connection.mindMap)
    var connections: [Connection]

    init(
        id: UUID = UUID(),
        title: String = "Untitled",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        nodes: [Node] = [],
        connections: [Connection] = []
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.nodes = nodes
        self.connections = connections
    }
}
```

### 5.2 Node Entity

```swift
import Foundation
import SwiftData

@Model
@MainActor
final class Node {
    /// Unique identifier for the node
    var id: UUID

    /// User-visible title text (max 10,000 characters)
    var title: String

    /// Additional notes in 10pt SF Pro Italic (max 10,000 characters)
    var notes: String

    /// X coordinate in canvas space
    var positionX: Double

    /// Y coordinate in canvas space
    var positionY: Double

    /// Hierarchy depth (0 = central, increases radially outward)
    var depth: Int

    /// Whether children are visible (expanded) or hidden (collapsed)
    var isExpanded: Bool

    /// ID of parent node (nil for central node)
    var parentId: UUID?

    /// Hue value for node color (0.0 - 1.0, HSB color space)
    var colorHue: Double

    /// Saturation for node color (0.0 - 1.0, HSB color space)
    var colorSaturation: Double

    /// Brightness for node color (0.0 - 1.0, HSB color space)
    var colorBrightness: Double

    /// Reference to parent mind map
    var mindMap: MindMap?

    /// Child nodes (populated by SwiftData relationship)
    @Relationship(deleteRule: .cascade)
    var children: [Node]

    init(
        id: UUID = UUID(),
        title: String = "",
        notes: String = "",
        positionX: Double = 0,
        positionY: Double = 0,
        depth: Int = 0,
        isExpanded: Bool = true,
        parentId: UUID? = nil,
        colorHue: Double = 0.0,
        colorSaturation: Double = 1.0,
        colorBrightness: Double = 0.7,
        mindMap: MindMap? = nil,
        children: [Node] = []
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.positionX = positionX
        self.positionY = positionY
        self.depth = depth
        self.isExpanded = isExpanded
        self.parentId = parentId
        self.colorHue = colorHue
        self.colorSaturation = colorSaturation
        self.colorBrightness = colorBrightness
        self.mindMap = mindMap
        self.children = children
    }

    /// Convenience accessor for position as CGPoint
    var position: CGPoint {
        get { CGPoint(x: positionX, y: positionY) }
        set {
            positionX = newValue.x
            positionY = newValue.y
        }
    }
}
```

### 5.3 Connection Entity

```swift
import Foundation
import SwiftData

@Model
@MainActor
final class Connection {
    /// Unique identifier for the connection
    var id: UUID

    /// ID of source node (where connection starts)
    var sourceNodeId: UUID

    /// ID of target node (where connection ends)
    var targetNodeId: UUID

    /// Hue value for line color (0.0 - 1.0, HSB color space)
    var colorHue: Double

    /// Saturation for line color (0.0 - 1.0, HSB color space)
    var colorSaturation: Double

    /// Brightness for line color (0.0 - 1.0, HSB color space)
    var colorBrightness: Double

    /// Reference to parent mind map
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
}
```

### 5.4 Spatial Index (Viewport Culling)

```swift
/// Spatial index for O(log n) viewport queries
/// Used for 60fps rendering with 10k+ nodes
struct SpatialIndex {
    /// QuadTree or R-tree for fast spatial queries
    /// Key: nodeId, Value: bounding rect
    var nodeBounds: [UUID: CGRect]

    /// Viewport query method
    /// - Parameter visibleRect: The currently visible rectangle
    /// - Returns: Set of node IDs intersecting visibleRect
    func nodesInRect(_ visibleRect: CGRect) -> Set<UUID> {
        // O(log n) spatial query implementation
    }
}
```

---

## SECTION 6: Platform Requirements (macOS)

### 6.1 Menu Bar

- [x] **File Menu**
  - [x] New (Cmd+N)
  - [x] Open (Cmd+O)
  - [x] Open Recent >
  - [x] Close (Cmd+W)
  - [x] Save (Cmd+S)
  - [x] Save As (Cmd+Shift+S)
  - [x] Export >
  - [x] Page Setup...
  - [x] Print...

- [x] **Edit Menu**
  - [x] Undo (Cmd+Z)
  - [x] Redo (Cmd+Shift+Z)
  - [x] Cut (Cmd+X)
  - [x] Copy (Cmd+C)
  - [x] Paste (Cmd+V)
  - [x] Select All (Cmd+A)
  - [x] Find >
  - [x] Spelling >
  - [x] Special Characters >

- [x] **View Menu**
  - [x] Zoom In (Cmd++)
  - [x] Zoom Out (Cmd+-)
  - [x] Zoom to 100% (Cmd+1)
  - [x] Reset View (Cmd+0)
  - [x] Toggle Fullscreen (Ctrl+Cmd+F)
  - [x] Enter Full Screen (Ctrl+Cmd+F)
  - [x] Dark Mode / Light Mode toggle

- [x] **Node Menu** (Application-specific)
  - [x] Add Child (Tab)
  - [x] Add Sibling (Cmd+Return)
  - [x] Delete Node (Cmd+Backspace)
  - [x] Duplicate Node (Cmd+D)
  - [x] Collapse All (Cmd+Shift+C)
  - [x] Expand All (Cmd+Shift+E)

- [x] **Window Menu**
  - [x] Minimize (Cmd+M)
  - [x] Zoom
  - [x] Bring All to Front

- [x] **Help Menu**
  - [x] Keyboard Shortcuts (Cmd+?)
  - [x] myMindMap Help

### 6.2 Dark Mode / Light Mode

- [x] Dark mode as default
- [x] Light mode available via View menu
- [x] Auto-follows macOS appearance setting
- [x] 300ms animated transition between modes

### 6.3 Keyboard Navigation

- [x] Full keyboard navigation implemented
- [x] All actions accessible via keyboard
- [x] Arrow keys for node navigation
- [x] Tab/Enter for node creation
- [x] Escape for cancel/dismiss

### 6.4 VoiceOver Accessibility

- [x] All interactive elements have accessibility labels
- [x] Node titles announced on selection
- [x] Node notes readable by VoiceOver
- [x] Keyboard shortcuts announced
- [x] Window title accessible

### 6.5 App Sandbox

- [x] App Sandbox enabled in entitlements
- [x] Hardened Runtime enabled
- [x] NSFileProtectionComplete for data files

### 6.6 Document-Based Application

- [x] NSDocument subclass for file handling
- [x] .mindmap file extension registered
- [x] UTI: com.mymindmap.document
- [x] Auto-save enabled
- [x] Version browser support

### 6.7 File Structure

```
~/Documents/myMindMap/
├── *.mindmap          (700 permissions)
├── *.mindmap.backup.* (700 permissions)
└── Trash/
```

### 6.8 Quantified Vague Terms

| Term | Quantification |
|------|----------------|
| auto-sizing font | depth 0=24pt, depth 1=18pt, depth 2=14pt, depth 3+=12pt min |
| thin italics | 10pt SF Pro Italic (constant) |
| colorful lines | 8 distinct HSB hues: 0°, 45°, 90°, 135°, 180°, 225°, 270°, 315° at 100% saturation, 70% brightness |
| thin lines | 1.5pt stroke width |
| auto-zoom to fit | on new/open/add: 50pt padding, 300ms ease-in-out animation |
| selected node | 2pt solid ring, color #007AFF (RGB: 0, 122, 255) |
| rounded rectangles | 8pt corner radius |
| viewport culling | only nodes intersecting visibleRect rendered |
| high quality fonts | SF Pro (system font), anti-aliasing enabled |
| fast save | atomic write with temp file, then rename |
| expand/collapse animation | 250ms ease-in-out |

---

## APPENDIX A: Color Palette

### 8 Distinct Node Connector Colors (HSB)

| Index | Hue (°) | Hue (normalized) | Saturation | Brightness | Hex |
|-------|---------|------------------|------------|------------|-----|
| 0 | 0° (Red) | 0.0 | 100% | 70% | #FF4D4D |
| 1 | 45° (Orange) | 0.125 | 100% | 70% | #FF9933 |
| 2 | 90° (Yellow) | 0.25 | 100% | 70% | #E6E600 |
| 3 | 135° (Green) | 0.375 | 100% | 70% | #80E600 |
| 4 | 180° (Cyan) | 0.5 | 100% | 70% | #00E6B3 |
| 5 | 225° (Blue) | 0.625 | 100% | 70% | #00A3E6 |
| 6 | 270° (Purple) | 0.75 | 100% | 70% | #8000E6 |
| 7 | 315° (Magenta) | 0.875 | 100% | 70% | #E60080 |

---

## APPENDIX B: Font Specifications

| Element | Font | Size | Weight | Style |
|---------|------|------|--------|-------|
| Node Title (depth 0) | SF Pro | 24pt | Semibold | Regular |
| Node Title (depth 1) | SF Pro | 18pt | Semibold | Regular |
| Node Title (depth 2) | SF Pro | 14pt | Semibold | Regular |
| Node Title (depth 3+) | SF Pro | 12pt | Semibold | Regular |
| Node Notes | SF Pro | 10pt | Regular | Italic |
| Search Field | SF Pro | 13pt | Regular | Regular |
| Shortcuts Window | SF Pro | 11pt | Regular | Regular |
| Status Bar | SF Mono | 10pt | Regular | Regular |

---

## APPENDIX C: Spacing & Layout

| Element | Value |
|---------|-------|
| Node minimum width | 100pt |
| Node maximum width | 300pt |
| Node vertical padding | 8pt |
| Node horizontal padding | 12pt |
| Node corner radius | 8pt |
| Connector stroke width | 1.5pt |
| Selected ring width | 2pt |
| Central node size | 120pt x 60pt |
| Child node offset (radial) | 150pt minimum |
| Angular spacing (radial) | Dynamic based on child count |
| Auto-fit padding | 50pt |
| Viewport update threshold | 16ms (60fps) |

---

## APPENDIX D: Animation Specifications

| Animation | Duration | Curve |
|-----------|----------|-------|
| Selection ring appear | 300ms | ease-out |
| Expand/collapse | 250ms | ease-in-out |
| Dark/Light mode transition | 300ms | ease-in-out |
| Auto-zoom to fit | 300ms | ease-in-out |
| Pan/zoom gesture | Immediate | linear |
| Shortcuts window appear | 200ms | ease-out |
| Search overlay appear | 150ms | ease-out |
| Node duplicate offset | Immediate | none |

---

*End of SPEC.md*
