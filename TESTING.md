# Testing Guide - myMindMap

This document outlines the testing strategy, quality standards, and test execution procedures for the myMindMap macOS application.

---

## 1. Test Suite Overview

### 1.1 Test Structure

```
Tests/
├── UnitTests/
│   ├── ModelTests/
│   │   ├── MindMapTests.swift
│   │   ├── MindMapNodeTests.swift
│   │   ├── NodeConnectionTests.swift
│   │   └── ThemeTests.swift
│   ├── ViewModelTests/
│   │   ├── CanvasViewModelTests.swift
│   │   ├── NodeViewModelTests.swift
│   │   ├── KeyboardViewModelTests.swift
│   │   └── MindMapViewModelTests.swift
│   └── UtilityTests/
│       ├── ColorExtensionTests.swift
│       ├── CGPointExtensionTests.swift
│       └── CGGeometryExtensionTests.swift
└── UITests/
    └── myMindMapUITests.swift
```

### 1.2 Test Coverage Goals

| Component | Target Coverage |
|-----------|-----------------|
| Models (MindMap, Node, Connection, Theme) | 90%+ |
| ViewModels | 85%+ |
| Utilities | 80%+ |
| Overall | 80%+ |

---

## 2. Unit Tests

### 2.1 Model Tests

#### MindMapTests
- Initialization with default and custom titles
- Root node retrieval
- Modified date tracking
- Node and connection management

#### MindMapNodeTests
- Node initialization
- Position property getter/setter
- Frame calculation
- Hierarchy (parent/children relationships)
- Color properties
- Collapse/expand state
- Font size

#### NodeConnectionTests
- Connection initialization
- Style management (straight, curved, bezier)
- Color properties
- MindMap association

#### ThemeTests
- Theme initialization
- Default light/dark themes
- Equatable conformance
- Color properties

### 2.2 ViewModel Tests

#### CanvasViewModelTests
- Zoom in/out operations
- Pan functionality
- Reset view
- Fit to screen
- Coordinate conversion (screen to canvas)
- Node hit testing
- Selection management
- Visible rect calculation

#### NodeViewModelTests
- Add child node
- Add sibling node
- Delete node (including recursive deletion)
- Node editing (start, finish, cancel)
- Node movement
- Collapse/expand toggle
- Node duplication

#### KeyboardViewModelTests
- Navigation keys (Tab, Return, Delete, Escape)
- Arrow keys
- Command shortcuts (Cmd+N, Cmd+S, Cmd+Z, etc.)
- Notification posting
- Last key press tracking

#### MindMapViewModelTests
- Create new mind map
- Save mind map
- Load recent mind maps
- Open mind map
- Delete mind map
- Dirty state management

### 2.3 Utility Tests

#### ColorExtensionTests
- Hex color initialization
- Hex conversion
- Edge cases (invalid input, whitespace, etc.)

#### CGPointExtensionTests
- Arithmetic operations (+, -, *, /)
- Distance calculation
- Midpoint calculation
- Angle calculation
- Rotation around a point

#### CGSizeExtensionTests
- Addition and subtraction
- Center calculation

#### CGRectExtensionTests
- Center property
- Initialization with center
- Expansion
- Contains in coordinate space

---

## 3. UI Tests (XCUITest)

### 3.1 Critical Flows

#### App Launch
- Verify app launches successfully
- Verify main window appears
- Measure launch performance

#### Mind Map Creation
- Create new mind map via menu
- Create new mind map via keyboard shortcut (Cmd+N)
- Verify root node appears

#### Node Interactions
- Select a node
- Edit node text
- Add child node (Tab)
- Add sibling node (Enter)
- Delete node (Delete key)

#### Keyboard Shortcuts
- Save (Cmd+S)
- Undo (Cmd+Z)
- Redo (Cmd+Shift+Z)
- Zoom in (Cmd+=)
- Zoom out (Cmd+-)
- Reset zoom (Cmd+0)
- Search (Cmd+F)
- Duplicate (Cmd+D)

#### Menu Bar
- Verify File menu exists
- Verify Edit menu exists
- Verify View menu exists

#### Accessibility
- Verify accessibility elements are present
- Verify VoiceOver compatibility structure

---

## 4. Quality Checklist

### 4.1 Performance Benchmarks

| Metric | Target | Test Method |
|--------|--------|-------------|
| App Launch Time | < 1 second | XCTApplicationLaunchMetric |
| Node Creation Latency | < 50ms | Performance measurement |
| Auto-save Latency | < 100ms | Performance measurement |
| Canvas Render (100 nodes) | 60fps | Frame rate monitoring |
| Canvas Render (1000 nodes) | 60fps | Frame rate monitoring |

### 4.2 Memory Usage Limits

| State | Limit |
|-------|-------|
| Idle | < 100MB |
| With 100 nodes | < 150MB |
| With 1000 nodes | < 300MB |

### 4.3 Accessibility Requirements

- [ ] Full VoiceOver support for all interactive elements
- [ ] Keyboard navigation for all features
- [ ] High contrast mode support
- [ ] Accessibility labels on all nodes and controls
- [ ] Accessibility hierarchy is correct

### 4.4 Edge Cases to Verify

1. **Empty State**
   - New user with no mind maps
   - Empty canvas view

2. **Large Data Sets**
   - 500+ nodes rendering smoothly
   - Deep hierarchies (10+ levels)

3. **Node Operations**
   - Deleting root node (should be prevented)
   - Deleting node with many children
   - Duplicating large subtrees

4. **Canvas Operations**
   - Zoom to minimum (0.1x)
   - Zoom to maximum (3.0x)
   - Pan to extreme positions

5. **Data Persistence**
   - App crash during save
   - Corrupted data recovery

6. **Keyboard Navigation**
   - All shortcuts work without focus issues
   - Arrow key navigation between nodes
   - Tab/Enter for node creation

---

## 5. Running Tests

### 5.1 Run All Tests

```bash
cd /Users/thotas/Development/MyAppsDev/myMindMap
xcodebuild test
```

### 5.2 Run Unit Tests Only

```bash
xcodebuild test -scheme myMindMap -only-testing:myMindMapTests/UnitTests
```

### 5.3 Run UI Tests Only

```bash
xcodebuild test -scheme myMindMap -only-testing:myMindMapTests/UITests
```

### 5.4 Run Specific Test File

```bash
xcodebuild test -scheme myMindMap -only-testing:myMindMapTests/UnitTests/ModelTests/MindMapTests
```

### 5.5 Generate Coverage Report

```bash
xcodebuild test -scheme myMindMap -enableCodeCoverage YES
```

---

## 6. CI/CD Integration

### 6.1 GitHub Actions

Tests should run automatically on every pull request and push to main. Add this to your workflow:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-14

    steps:
      - uses: actions/checkout@v4

      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_15.0.app

      - name: Build and Test
        run: |
          xcodebuild test -scheme myMindMap \
            -enableCodeCoverage YES \
            -destination 'platform=macOS'
```

---

## 7. Known Limitations

1. **SwiftData Testing**: Some ViewModel tests require in-memory ModelContext. Full persistence tests should be done manually.

2. **UI Test Stability**: Some UI tests may be flaky due to timing issues. Retry mechanism recommended.

3. **Keyboard Shortcut Tests**: Testing actual keyboard shortcuts in XCUITest can be environment-dependent.

---

## 8. Test Maintenance

- Review and update tests when adding new features
- Keep test coverage above 80%
- Add regression tests for bug fixes
- Document any test workarounds or skips

---

*Last Updated: 2026-03-10*
