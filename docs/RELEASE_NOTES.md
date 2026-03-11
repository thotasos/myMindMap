# Release Notes — myMindMap

**Version 1.0**
**Release Date:** March 10, 2026

---

## Welcome to myMindMap 1.0

myMindMap is a minimalist, keyboard-driven mind mapping application designed for productivity-focused professionals. This release includes all core features for creating, editing, and organizing mind maps with a beautiful native macOS experience.

---

## New Features

### Mind Map Creation
- **Quick Start**: Create new mind maps instantly with Cmd+N
- **Root Node**: Auto-generated central node with customizable title
- **Templates**: Pre-built templates for common use cases:
  - Blank Map
  - Project Plan
  - Brainstorm
  - Decision Tree

### Node Editing
- **Inline Editing**: Double-click or press Enter to edit node text
- **Rich Text**: Basic formatting support within nodes
- **Auto-save**: All changes saved automatically to local storage

### Node Organization
- **Add Child**: Tab key adds child to selected node
- **Add Sibling**: Enter key adds sibling node
- **Move Nodes**: Drag-and-drop or keyboard shortcuts to reorder
- **Collapse/Expand**: Collapse subtrees to reduce visual clutter
- **Delete**: Delete or Backspace key removes nodes

### Keyboard Shortcuts
Comprehensive keyboard-first design with shortcuts for:
- All node operations (add, edit, delete, move)
- Navigation (zoom, pan, focus mode)
- Search and export

### Navigation and View
- **Pan**: Click and drag canvas, or use trackpad
- **Zoom**: Cmd+/-, trackpad pinch, or scroll wheel
- **Fit to Screen**: Cmd+0 to fit entire map
- **Focus Mode**: Dim all nodes except selected branch
- **Mini Map**: Optional overview panel for large maps

### Export and Integration
- **Export Formats**: PDF, PNG, Markdown, JSON
- **Import**: Import from JSON and Markdown
- **Copy as Markdown**: Copy selected subtree to clipboard

### Persistence and Storage
- **Local Storage**: All mind maps stored locally using SQLite
- **Recent Files**: Quick access to last 10 opened mind maps
- **Auto-save**: Changes saved within 1 second of editing

### Search
- **Full-text Search**: Find any text in your mind map
- **Real-time Results**: Results update as you type
- **Navigate Results**: Jump between matches

### Themes
Beautiful theme options:
- Light (default)
- Dark
- Ocean
- Forest
- Sunset

### Undo/Redo
- Full action history for all operations

---

## Improvements

### Performance
- App launches in under 1 second
- All UI interactions respond in under 50ms
- Canvas maintains 60fps with 500+ nodes
- Memory usage under 100MB when idle

### Design
- Native macOS look and feel
- Follows Apple Human Interface Guidelines
- Smooth 60fps animations
- Keyboard shortcut hints appear contextually

### Accessibility
- Full VoiceOver support
- High contrast mode support
- Keyboard navigation for all features

---

## Known Issues

### Version 1.0

| Issue | Status | Workaround |
|-------|--------|------------|
| Mini Map not showing in some window sizes | Known | Resize window or use Cmd+0 |
| Large maps (1000+ nodes) may experience slight lag | Known | Collapse branches not in use |
| Markdown import may not preserve all formatting | Known | Review imported content manually |
| Some third-party keyboard shortcuts may conflict | Known | Customize system shortcuts if needed |

### Limitations (By Design)

The following features are planned for future releases:

- iCloud sync (coming in 2.0)
- Custom themes beyond 5 presets (coming in 2.0)
- Keyboard shortcut customization (coming in 2.0)
- Node colors customization (coming in 2.0)
- Collaboration features (future)
- iOS companion app (future)
- Voice input (future)
- AI integration (future)
- Presentation mode (future)

---

## System Requirements

- macOS 13.0 (Ventura) or later
- Mac with Apple Silicon or Intel processor
- 100MB disk space
- 100MB RAM minimum

---

## Upgrading from Beta

If you were using a beta version:

1. **Backup your data**: Export any important mind maps
2. **Uninstall beta**: Remove from Applications
3. **Install 1.0**: Download from Mac App Store or website
4. **Restore data**: Import your exports if needed

---

## Coming Soon

We're already working on version 1.1:

- PDF export with layout options
- High-resolution PNG export
- Enhanced collapse/expand functionality
- Full-text search improvements
- Copy as Markdown enhancements

Stay tuned for updates!

---

## Feedback

We'd love to hear from you:

- **Help > Contact Support**: Report bugs or request features
- **Mac App Store**: Leave a review
- **Website**: Visit for more resources

Thank you for choosing myMindMap!

---

*Copyright 2026 myMindMap. All rights reserved.*
