# myMindMap

A minimalist, keyboard-driven mind mapping application for macOS designed for productivity-focused professionals who value frictionless workflows and native macOS experiences.

## Overview

myMindMap empowers users to capture, organize, and visualize ideas rapidly without the cognitive overhead of complex tooling. Every action is achievable via keyboard shortcuts, making it the perfect tool for power users who prefer keyboard-driven workflows.

## Features

### Core Features

- **Keyboard-First Design**: Every action achievable via keyboard shortcuts - never reach for the mouse
- **Infinite Canvas**: Pan and zoom to navigate large mind maps effortlessly
- **Inline Node Editing**: Double-click or press Enter to edit node text directly
- **Node Hierarchy**: Add child nodes (Tab), sibling nodes (Enter), and organize your thoughts structurally
- **Collapse/Expand**: Focus on relevant sections by collapsing subtrees
- **Auto-Save**: All changes saved automatically - never lose your work
- **Multiple Themes**: Choose from Light, Dark, Ocean, Forest, and Sunset themes

### Export Options

- **PDF**: Export mind maps as PDF documents
- **PNG**: Export high-resolution images
- **Markdown**: Copy structure as Markdown to clipboard
- **JSON**: Export for interoperability with other tools

### Navigation

- **Quick Search**: Find any node instantly with Cmd+F
- **Recent Maps**: Quick access to your last 10 opened mind maps
- **Focus Mode**: Dim non-relevant nodes to focus on specific branches

## Tech Stack

| Component | Technology |
|-----------|------------|
| **UI Framework** | SwiftUI |
| **Persistence** | SwiftData |
| **Language** | Swift 5.9 |
| **Minimum macOS** | 14.0 (Sonoma) |
| **Architecture** | MVVM |
| **Build System** | XcodeGen |

### Native Frameworks Used

- SwiftUI - UI Framework
- SwiftData - Persistence and data modeling
- Foundation - Core utilities
- AppKit - macOS integration
- UniformTypeIdentifiers - File types for export

## Requirements

- macOS 14.0 (Sonoma) or later
- Apple Silicon or Intel Mac

## Building the Project

### Prerequisites

1. Install XcodeGen if not already installed:
   ```bash
   brew install xcodegen
   ```

2. Ensure Xcode is installed from the Mac App Store

### Build Steps

1. Navigate to the project directory:
   ```bash
   cd /Users/thotas/Development/MyAppsDev/myMindMap
   ```

2. Generate the Xcode project:
   ```bash
   xcodegen generate
   ```

3. Open the generated project:
   ```bash
   open myMindMap.xcodeproj
   ```

4. Build and run (Cmd+R) in Xcode

### Alternative: Build from Command Line

```bash
cd /Users/thotas/Development/MyAppsDev/myMindMap
xcodegen generate
xcodebuild -project myMindMap.xcodeproj -scheme myMindMap -configuration Debug build
```

## Running the App

After building, you can run the app in several ways:

1. **From Xcode**: Press Cmd+R to build and run
2. **From Finder**: Open the built app at `~/Library/Developer/Xcode/DerivedData/myMindMap-*/Build/Products/Debug/myMindMap.app`
3. **From Terminal**: Open the built app using `open` command

### First Launch

On first launch, you'll see a welcome screen with:
- "New Map" button to create your first mind map
- Recent maps section (empty initially)
- Templates section for quick starts

Press **Cmd+N** from anywhere to create a new mind map.

## Keyboard Shortcuts Reference

### File Operations

| Action | Shortcut |
|--------|----------|
| New Mind Map | Cmd+N |
| Save | Cmd+S |
| Open | Cmd+O |
| Close | Cmd+W |
| Quit | Cmd+Q |

### Node Operations

| Action | Shortcut |
|--------|----------|
| Add Child Node | Tab |
| Add Sibling Node | Enter |
| Edit Node | Enter (when selected) |
| Delete Node | Delete / Backspace |
| Duplicate Node | Cmd+D |
| Collapse/Expand | Cmd+Enter |
| Cut | Cmd+X |
| Copy | Cmd+C |
| Paste | Cmd+V |

### Navigation

| Action | Shortcut |
|--------|----------|
| Navigate Up | Arrow Up |
| Navigate Down | Arrow Down |
| Navigate Left | Arrow Left |
| Navigate Right | Arrow Right |
| Move Node Up | Cmd+Arrow Up |
| Move Node Down | Cmd+Arrow Down |
| Search | Cmd+F |
| Fit to Screen | Cmd+0 |

### View Controls

| Action | Shortcut |
|--------|----------|
| Zoom In | Cmd++ |
| Zoom Out | Cmd+- |
| Actual Size | Cmd+0 |
| Focus Mode | Cmd+Shift+F |
| Toggle Sidebar | Cmd+Opt+S |
| Show Mini Map | Cmd+M |

### Undo/Redo

| Action | Shortcut |
|--------|----------|
| Undo | Cmd+Z |
| Redo | Cmd+Shift+Z |

### Help

| Action | Shortcut |
|--------|----------|
| Show Shortcuts | ? (when canvas focused) |
| Help | Cmd+? |

## Project Structure

```
myMindMap/
├── Sources/
│   ├── App/
│   │   └── MyMindMapApp.swift          # App entry point
│   ├── Models/
│   │   ├── MindMap.swift               # Mind map data model
│   │   ├── Node.swift                  # Node data model
│   │   ├── Connection.swift            # Connection between nodes
│   │   └── Theme.swift                # Theme configuration
│   ├── ViewModels/
│   │   ├── MindMapViewModel.swift      # Mind map lifecycle management
│   │   ├── CanvasViewModel.swift      # Canvas state and viewport
│   │   ├── NodeViewModel.swift        # Node editing and manipulation
│   │   └── KeyboardViewModel.swift    # Keyboard shortcut handling
│   ├── Views/
│   │   ├── ContentView.swift          # Main window content
│   │   ├── Canvas/
│   │   │   ├── CanvasView.swift       # Infinite canvas
│   │   │   ├── ConnectionsLayerView.swift
│   │   │   └── NodesLayerView.swift
│   │   ├── Nodes/
│   │   │   └── NodeView.swift         # Node rendering
│   │   ├── Toolbar/
│   │   │   └── ToolbarView.swift      # Toolbar actions
│   │   └── Overlays/
│   │       ├── StatusBarView.swift    # Status bar
│   │       └── SearchOverlayView.swift
│   └── Utilities/
│       ├── Extensions/
│       │   ├── Color+Hex.swift
│       │   └── CGPoint+Extensions.swift
│       └── Constants.swift
├── Resources/
│   ├── Assets.xcassets/
│   ├── Info.plist
│   └── myMindMap.entitlements
├── project.yml                         # XcodeGen configuration
└── README.md                           # This file
```

## Architecture

myMindMap follows the **MVVM (Model-View-ViewModel)** architecture pattern with SwiftUI:

- **Models**: SwiftData models for persistence (MindMap, Node, Connection, Theme)
- **ViewModels**: Business logic and state management (@Observable classes)
- **Views**: SwiftUI views for rendering

See [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed technical documentation.

## Design System

The app follows a comprehensive design system with 5 themes:

- **Light**: Clean, minimal, paper-like
- **Dark**: Deep, comfortable, modern
- **Ocean**: Blue tones, professional
- **Forest**: Green accents, natural
- **Sunset**: Warm gradients, energetic

See [DESIGN_SYSTEM.md](./DESIGN_SYSTEM.md) for complete design specifications.

## Contributing

We welcome contributions to myMindMap. Please follow these guidelines:

### Reporting Issues

- Use GitHub Issues to report bugs or request features
- Include macOS version and steps to reproduce for bugs

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes with clear messages
4. Push to the branch
5. Open a Pull Request

### Development Setup

1. Clone the repository
2. Run `xcodegen generate` to generate the Xcode project
3. Open in Xcode and start developing

### Code Style

- Follow Swift API Design Guidelines
- Use Swift's modern features (async/await, @Observable)
- Add documentation for public interfaces

## License

MIT License

Copyright (c) 2026 myMindMap

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

Built with SwiftUI and SwiftData for macOS
