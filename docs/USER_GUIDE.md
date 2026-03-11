# User Guide — myMindMap

A comprehensive guide to using myMindMap for mac Table of Contents

OS.

---

##1. [Interface Overview](#1-interface-overview)
2. [Creating Mind Maps](#2-creating-mind-maps)
3. [Editing Nodes](#3-editing-nodes)
4. [Organizing Nodes](#4-organizing-nodes)
5. [Navigation](#5-navigation)
6. [Search](#6-search)
7. [Export Options](#7-export-options)
8. [Preferences](#8-preferences)

---

## 1. Interface Overview

### 1.1 Main Window Structure

The myMindMap window consists of three main areas:

```
┌─────────────────────────────────────────────────────────────┐
│ Toolbar (44pt)                                              │
├─────────────┬───────────────────────────────────────────────┤
│             │                                               │
│  Sidebar    │           Canvas Area                        │
│  (240pt)    │           (infinite scroll)                  │
│             │                                               │
│             │                                               │
└─────────────┴───────────────────────────────────────────────┘
```

### 1.2 Toolbar

The toolbar provides quick access to common actions:

| Item | Description |
|------|-------------|
| New Map | Create a new mind map (Cmd+N) |
| Undo/Redo | Revert or repeat actions |
| Style Picker | Change node styling |
| Color Picker | Apply colors to nodes |
| Search | Open search (Cmd+F) |
| Zoom Controls | Zoom in/out, fit to screen |
| Export | Export current map (Cmd+E) |

### 1.3 Sidebar

The sidebar shows:

- **Recent Maps**: Your last opened mind maps (up to 10)
- **Templates**: Quick-start templates

Collapse the sidebar with **Cmd+Opt+S**.

### 1.4 Canvas

The canvas is your infinite workspace:

- **Pan**: Click and drag on empty space, or use trackpad
- **Zoom**: Pinch, scroll wheel, or Cmd++/Cmd+-
- **Nodes**: Your mind map content

---

## 2. Creating Mind Maps

### 2.1 New Mind Map

**Method 1: Keyboard**
- Press **Cmd+N** anywhere in the app
- A new canvas appears with a root node

**Method 2: Welcome Screen**
- Click the large **New Map** button on the welcome screen

**Method 3: File Menu**
- Go to **File > New Map** (Cmd+N)

### 2.2 Templates

Start with a pre-built template:

| Template | Best For |
|----------|----------|
| Blank Map | Starting from scratch |
| Project Plan | Project management structure |
| Brainstorming | Idea generation sessions |
| Decision Tree | Making decisions with branches |

**To use a template:**
1. Go to **File > New Map from Template**
2. Select a template
3. A new mind map appears with placeholder content

### 2.3 Root Node

The root node is the central topic of your mind map:

- Auto-created when you make a new map
- Displayed with a distinct style (larger, accent border)
- Rename by typing immediately or double-clicking

---

## 3. Editing Nodes

### 3.1 Selecting Nodes

- **Single click** to select
- **Arrow keys** to navigate between nodes
- Selected node has a blue border

### 3.2 Editing Node Text

**Method 1: Double-click**
- Double-click any node to enter edit mode

**Method 2: Keyboard**
- Select a node and press **Enter**
- The node becomes editable

**In edit mode:**
- Type to add or modify text
- Press **Enter** to confirm changes
- Press **Escape** to cancel

### 3.3 Node Types

Currently supported:

| Type | Description |
|------|-------------|
| Text Node | Standard node with text content |
| Root Node | Central topic of the map |

### 3.4 Node Colors

Color-code your nodes to categorize ideas:

| Color | Meaning |
|-------|---------|
| Default | General content |
| Blue | Ideas, new items |
| Green | Completed, positive |
| Yellow | In progress, caution |
| Orange | Priority, attention |
| Red | Urgent, problems |
| Purple | Creative, special |
| Gray | Archived, neutral |

**To change node color:**
1. Select a node
2. Use the **Color Picker** in the toolbar, or
3. Right-click > **Change Color** > select a color

### 3.5 Auto-Save

All changes are saved automatically:

- Saves within 1 second of editing
- No manual save required
- App reopens to last state

---

## 4. Organizing Nodes

### 4.1 Adding Nodes

**Add Child Node (Tab)**
- Select a node
- Press **Tab**
- A new child node appears below

**Add Sibling Node (Enter)**
- Select a node
- Press **Enter**
- A new node appears at the same level

### 4.2 Deleting Nodes

- Select a node
- Press **Delete** or **Backspace**
- The node and all children are removed

**Undo deletion:**
- Press **Cmd+Z** immediately

### 4.3 Moving Nodes

**Drag and Drop:**
- Click and drag a node to a new position
- Drop on another node to make it a child

**Keyboard:**
- **Cmd+Up**: Move node up among siblings
- **Cmd+Down**: Move node down among siblings

### 4.4 Collapse and Expand

Hide subtrees to reduce clutter:

**Toggle collapse/expand:**
- Select a node with children
- Press **Cmd+Enter**

**Visual indicator:**
- Collapsed nodes show "..." or a child count badge
- Collapsed nodes display in italic

---

## 5. Navigation

### 5.1 Panning the Canvas

| Method | How |
|--------|-----|
| Mouse | Click and drag on empty canvas |
| Trackpad | Two-finger scroll |
| Keyboard | Not available (use mouse/trackpad) |

### 5.2 Zooming

| Action | Shortcut |
|--------|----------|
| Zoom In | **Cmd++** |
| Zoom Out | **Cmd+-** |
| Fit to Screen | **Cmd+0** |
| Actual Size | **Cmd+1** |

**Zoom range:** 10% to 400%

### 5.3 Focus Mode

Focus on one branch at a time:

1. Select a node
2. Press **Cmd+Shift+F**

**In Focus Mode:**
- Selected branch is fully visible
- Other nodes are dimmed (20% opacity)
- Press **Escape** to exit

### 5.4 Mini Map

For large mind maps, enable the Mini Map:

1. Go to **View > Show Mini Map** (Cmd+M)
2. Mini Map appears in bottom-right corner
3. Click on Mini Map to navigate

---

## 6. Search

### 6.1 Finding Nodes

1. Press **Cmd+F** or click the search field
2. Type your search term
3. Results appear in real-time

### 6.2 Navigating Results

- **Enter**: Jump to next match
- **Cmd+Enter**: Jump to previous match
- **Escape**: Close search

### 6.3 Search Highlights

- Matching text is highlighted in results
- Matching nodes are highlighted on canvas

---

## 7. Export Options

### 7.1 Export Formats

| Format | Use Case |
|--------|----------|
| PDF | Documents, printing |
| PNG | Images, presentations |
| Markdown | Notes, docs, GitHub |
| JSON | Backup, data exchange |

### 7.2 Exporting

**Method 1: Menu**
- Go to **File > Export** > select format

**Method 2: Keyboard**
- Press **Cmd+E**
- Choose format and options
- Click Export

**Method 3: Quick Export**
- **Cmd+Shift+C**: Copy selected subtree as Markdown to clipboard

### 7.3 Export Options

When exporting, you can choose:

- **Include title**: Add map title to export
- **Include timestamp**: Add date to export
- **Zoom level**: Current view or fit entire map
- **Theme**: Current, Light, or Dark

### 7.4 Import

Import existing files:

- **JSON**: File > Open (Cmd+O)
- **Markdown**: Converts outline structure to mind map

---

## 8. Preferences

### 8.1 Accessing Preferences

- Press **Cmd+,** (Cmd+comma)
- Or go to **myMindMap > Preferences**

### 8.2 General Tab

| Setting | Description |
|---------|-------------|
| Launch behavior | What to show on launch |
| Auto-save interval | How often to save (1-10 seconds) |
| Recent maps count | Show 5-50 recent maps |

### 8.3 Appearance Tab

| Setting | Description |
|---------|-------------|
| Theme | Light, Dark, Ocean, Forest, Sunset |
| Node font | Font family for nodes |
| Connection style | Curved or orthogonal lines |

### 8.4 Shortcuts Tab

View all keyboard shortcuts:

- Predefined shortcuts listed
- Click to see what each does
- (Customization coming in future update)

### 8.5 Advanced Tab

| Setting | Description |
|---------|-------------|
| Canvas performance | Toggle optimizations |
| Debug mode | For troubleshooting |

---

## Keyboard Shortcuts Reference

### File Operations

| Action | Shortcut |
|--------|----------|
| New Map | Cmd+N |
| Open | Cmd+O |
| Save | Cmd+S |
| Save As | Cmd+Shift+S |
| Export | Cmd+E |
| Close | Cmd+W |
| Quit | Cmd+Q |

### Edit Operations

| Action | Shortcut |
|--------|----------|
| Undo | Cmd+Z |
| Redo | Cmd+Shift+Z |
| Cut | Cmd+X |
| Copy | Cmd+C |
| Paste | Cmd+V |
| Delete | Delete / Backspace |
| Select All | Cmd+A |

### Node Operations

| Action | Shortcut |
|--------|----------|
| Add Child | Tab |
| Add Sibling | Enter |
| Edit Node | Enter / Double-click |
| Move Up | Cmd+Up |
| Move Down | Cmd+Down |
| Collapse/Expand | Cmd+Enter |

### Navigation

| Action | Shortcut |
|--------|----------|
| Search | Cmd+F |
| Zoom In | Cmd++ |
| Zoom Out | Cmd+- |
| Fit to Screen | Cmd+0 |
| Focus Mode | Cmd+Shift+F |
| Toggle Sidebar | Cmd+Opt+S |
| Show Mini Map | Cmd+M |

### Help

| Action | Shortcut |
|--------|----------|
| Show Shortcuts | ? |

---

## Troubleshooting

### App Won't Launch
- Ensure macOS 13.0 or later
- Try restarting your Mac
- Check for updates

### Lost Work
- Auto-save typically prevents data loss
- Check Recent Maps (File > Open Recent)
- Recover from Time Machine backup

### Slow Performance
- Reduce number of visible nodes
- Collapse branches you don't need
- Lower zoom level

### Export Issues
- Ensure sufficient disk space
- Try different export format
- Check file permissions

---

## Contact Support

If you need help:

- Go to **Help > Contact Support**
- Visit our support website
- Check **Help > Release Notes** for updates
