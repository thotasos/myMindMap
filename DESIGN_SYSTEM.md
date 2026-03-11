# Design System — myMindMap

**Project**: myMindMap — Minimalist macOS Mind Mapping Application
**Version**: 1.0
**Date**: 2026-03-10
**Owner**: UI/UX Design

---

## Table of Contents

1. [Design Philosophy](#1-design-philosophy)
2. [Color Palette](#2-color-palette)
3. [Typography System](#3-typography-system)
4. [Spacing and Layout](#4-spacing-and-layout)
5. [Component Library](#5-component-library)
6. [Wireframe Descriptions](#6-wireframe-descriptions)
7. [Animation Specifications](#7-animation-specifications)
8. [macOS-Specific Elements](#8-macos-specific-elements)

---

## 1. Design Philosophy

### Core Principles

**1.1 "Invisible Tool" Philosophy**

myMindMap is designed to be invisible — the tool should get out of the way and let users think about their ideas, not the interface.

- Every interaction should feel instant and natural
- No modal dialogs for common actions
- Progressive disclosure: simple interface initially, advanced features available but unobtrusive
- The interface recedes; the content emerges

**1.2 Keyboard-First Design**

Every action achievable via keyboard. The mouse is optional, not required.

- Design keyboard shortcuts into every interaction from the start
- Visual shortcuts hints appear contextually, not permanently cluttering the interface
- Support standard macOS conventions (Cmd for commands, Opt for modifiers, arrows for navigation)
- Alternative Vim-style navigation (j/k) available for power users

**1.3 Minimalist Aesthetic**

Less is more. Every element must earn its place on screen.

- Generous white space to let content breathe
- Subtle shadows and borders rather than heavy strokes
- Single-purpose UI elements — no multi-functional buttons that confuse
- Content is king; chrome is queen

**1.4 Native macOS Feel**

The app feels like it belongs on macOS — an extension of the operating system.

- Follow Apple Human Interface Guidelines (HIG) precisely
- Use system fonts, system colors where appropriate
- Integrate with macOS features (toolbar, menu bar, keyboard shortcuts)
- Respect macOS design language: translucency, vibrancy, spring animations

**1.5 Frictionless Flow**

Remove all barriers between idea and capture.

- Sub-1-second launch time
- Instant response on every interaction (<50ms)
- Auto-save without user intervention
- One keystroke to start a new mind map and begin typing

---

## 2. Color Palette

### 2.1 Theme Architecture

myMindMap supports 5 beautiful themes:

| Theme | Description | Use Case |
|-------|-------------|----------|
| **Light** | Clean, minimal, paper-like | Daytime work, presentations |
| **Dark** | Deep, comfortable, modern | Low-light environments, focus |
| **Ocean** | Blue tones, professional | Corporate settings, calm focus |
| **Forest** | Green accents, natural | Creative work, growth planning |
| **Sunset** | Warm gradients, energetic | Brainstorming, ideation sessions |

### 2.2 Light Theme

```
Background Canvas:    #FFFFFF (pure white)
Background Secondary: #F5F5F7 (system gray 6)
Surface:              #FFFFFF (white)
Surface Elevated:     #FAFAFA (off-white)

Text Primary:         #1D1D1F (system label)
Text Secondary:       #86868B (system secondary label)
Text Tertiary:       #AEAEB2 (system tertiary label)

Accent Primary:       #007AFF (system blue)
Accent Success:       #34C759 (system green)
Accent Warning:       #FF9500 (system orange)
Accent Danger:        #FF3B30 (system red)

Node Default:         #F5F5F7 (light gray fill)
Node Selected:        #E8F0FE (light blue tint)
Node Hover:           #F0F0F5 (subtle highlight)

Connection Line:      #D1D1D6 (system gray 4)
Connection Line Bold:#86868B (secondary text)

Border Default:       #E5E5EA (system gray 5)
Border Focused:      #007AFF (accent blue)
```

### 2.3 Dark Theme

```
Background Canvas:    #000000 (pure black)
Background Secondary: #1C1C1E (system gray 6 dark)
Surface:              #1C1C1E (dark surface)
Surface Elevated:    #2C2C2E (slightly lighter)

Text Primary:         #FFFFFF (white)
Text Secondary:      #98989D (system gray 2)
Text Tertiary:       #636366 (system gray 3)

Accent Primary:      #0A84FF (system blue dark)
Accent Success:      #30D158 (system green dark)
Accent Warning:      #FF9F0A (system orange dark)
Accent Danger:       #FF453A (system red dark)

Node Default:        #2C2C2E (dark gray fill)
Node Selected:      #1E3A5F (dark blue tint)
Node Hover:         #3A3A3C (subtle highlight)

Connection Line:     #48484A (system gray 4 dark)
Connection Line Bold:#98989D (secondary text)

Border Default:      #38383A (dark border)
Border Focused:     #0A84FF (accent blue dark)
```

### 2.4 Ocean Theme

```
Background Canvas:    #F8FAFC (cool white)
Background Secondary: #E2E8F0 (slate 200)
Surface:              #FFFFFF (white)
Surface Elevated:    #F1F5F9 (slate 100)

Text Primary:         #0F172A (slate 900)
Text Secondary:      #475569 (slate 600)
Text Tertiary:       #94A3B8 (slate 400)

Accent Primary:       #0284C7 (sky 600) — main accent
Accent Secondary:    #0EA5E9 (sky 500)
Accent Tertiary:      #38BDF8 (sky 400)

Node Default:        #E0F2FE (sky 100)
Node Selected:       #BAE6FD (sky 200)
Node Hover:          #F0F9FF (sky 50)

Connection Line:     #CBD5E1 (slate 300)
Connection Line Bold:#0284C7 (accent)

Gradient Accent:     linear-gradient(135deg, #0284C7, #0EA5E9)
```

### 2.5 Forest Theme

```
Background Canvas:    #FAFDF7 (mint cream)
Background Secondary: #ECF4E8 (honeydew)
Surface:              #FFFFFF (white)
Surface Elevated:    #F3F8EE (pale green)

Text Primary:         #1A2E1A (dark forest)
Text Secondary:      #4A6B4A (forest green)
Text Tertiary:       #7FA07F (sage)

Accent Primary:       #2E7D32 (forest 700) — main accent
Accent Secondary:    #4CAF50 (green 500)
Accent Tertiary:     #81C784 (green 300)

Node Default:        #E8F5E9 (green 50)
Node Selected:       #C8E6C9 (green 100)
Node Hover:          #F1F8E9 (light green)

Connection Line:     #A5D6A7 (green 200)
Connection Line Bold:#2E7D32 (accent)

Gradient Accent:     linear-gradient(135deg, #2E7D32, #4CAF50)
```

### 2.6 Sunset Theme

```
Background Canvas:    #FFFBF5 (warm white)
Background Secondary: #FFF0E6 (peach)
Surface:              #FFFFFF (white)
Surface Elevated:    #FFF5EB (light peach)

Text Primary:         #1A1512 (warm black)
Text Secondary:       #5C4D42 (warm brown)
Text Tertiary:        #9E8B80 (taupe)

Accent Primary:       #E65100 (orange 900) — main accent
Accent Secondary:     #FF6D00 (orange A700)
Accent Tertiary:      #FF9100 (orange A400)

Node Default:         #FFF3E0 (orange 50)
Node Selected:       #FFE0B2 (orange 100)
Node Hover:          #FFF8E1 (amber 50)

Connection Line:      #FFCC80 (orange 200)
Connection Line Bold: #E65100 (accent)

Gradient Accent:     linear-gradient(135deg, #E65100, #FF6D00)
```

### 2.7 Node Color Variants

Each theme supports 8 node color options for categorization:

| Color Name | Light Theme | Dark Theme | Usage |
|------------|-------------|------------|-------|
| Default | #F5F5F7 | #2C2C2E | General nodes |
| Blue | #E3F2FD | #1E3A5F | Ideas, new items |
| Green | #E8F5E9 | #1B3D1B | Completed, positive |
| Yellow | #FFFDE7 | #3D3D1A | In progress, caution |
| Orange | #FFF3E0 | #3D321A | Priority, attention |
| Red | #FFEBEE | #3D1B1B | Urgent, problems |
| Purple | #F3E5F5 | #2D1B3D | Creative, special |
| Gray | #F5F5F5 | #3A3A3A | Archived, neutral |

---

## 3. Typography System

### 3.1 Font Family

**Primary Font: SF Pro** (system font)

- Use `Font.system(.body)` and variants in SwiftUI
- SF Pro is automatically optimized for the current display
- Supports Dynamic Type for accessibility
- Automatic weight switching between regular and medium

**Monospace (for code/technical nodes): SF Mono**

- Use for technical mind maps
- Use `Font.system(.body, design: .monospace)` in SwiftUI

### 3.2 Type Scale

| Style | Font | Size | Weight | Line Height | Use Case |
|-------|------|------|--------|-------------|----------|
| **Large Title** | SF Pro | 34pt | Bold | 41pt | Welcome screen |
| **Title 1** | SF Pro | 28pt | Bold | 34pt | Root node (default) |
| **Title 2** | SF Pro | 22pt | Bold | 28pt | Major branch nodes |
| **Title 3** | SF Pro | 20pt | Semibold | 25pt | Secondary nodes |
| **Headline** | SF Pro | 17pt | Semibold | 22pt | Node toolbar |
| **Body** | SF Pro | 15pt | Regular | 20pt | Standard node text |
| **Callout** | SF Pro | 13pt | Regular | 18pt | Secondary text, hints |
| **Caption 1** | SF Pro | 12pt | Regular | 16pt | Timestamps, metadata |
| **Caption 2** | SF Pro | 11pt | Regular | 13pt | Subtle labels |

### 3.3 Node Text Styles

```
Root Node:
- Font: Title 1 (28pt Bold)
- Color: Text Primary
- Padding: 16pt horizontal, 12pt vertical

Branch Node (Level 1):
- Font: Title 3 (20pt Semibold)
- Color: Text Primary
- Padding: 12pt horizontal, 8pt vertical

Leaf Node:
- Font: Body (15pt Regular)
- Color: Text Primary
- Padding: 10pt horizontal, 6pt vertical

Collapsed Node (with children):
- Font: Body (15pt Regular, Italic)
- Color: Text Secondary
- Suffix: "..." or child count badge

Placeholder Text:
- Font: Body (15pt Regular)
- Color: Text Tertiary
- Text: "Type here..." or "New idea"
```

### 3.4 Keyboard Shortcut Hints

```
Format: SF Pro, 11pt, Medium
Color: Text Tertiary (on hover: Accent Primary)
Background: Surface Elevated with 8pt corner radius
Padding: 4pt horizontal, 2pt vertical
Opacity: 0.8 (fade to 0.4 when not relevant)
```

---

## 4. Spacing and Layout

### 4.1 Grid System

**Base Unit: 4pt**

All spacing values are multiples of 4:

```
4pt   — Micro spacing (icon padding)
8pt   — Tight spacing (inline elements)
12pt  — Default spacing (component internal)
16pt  — Comfortable spacing (between elements)
24pt  — Section spacing (grouped elements)
32pt  — Large spacing (section dividers)
48pt  — Page margins (main content areas)
64pt  — Hero spacing (major visual anchors)
```

### 4.2 Canvas Layout

```
Node Minimum Size:
- Width: 80pt (auto-expands with content)
- Height: 40pt (single line) / auto (multi-line)

Node Maximum Size:
- Width: 400pt (then wraps text)
- Height: Unlimited (scrollable within node)

Node Horizontal Spacing:
- Between siblings: 48pt minimum
- Adjustable via drag: 24pt – 120pt

Node Vertical Spacing:
- Between levels: 64pt minimum
- Auto-layout ensures no overlap

Connection Lines:
- Stroke width: 2pt (default), 3pt (selected path)
- Curvature: Bezier curves with 0.3 tension
- Arrow heads: 6pt equilateral triangle (optional)
```

### 4.3 Interface Layout

**Main Window Structure:**

```
┌─────────────────────────────────────────────────────────────┐
│ Toolbar (44pt height)                                       │
├─────────────┬───────────────────────────────────────────────┤
│             │                                               │
│  Sidebar    │           Canvas Area                        │
│  (240pt     │           (infinite scroll)                  │
│  width,     │                                               │
│  collapsible│                                               │
│             │                                               │
│             │                                               │
│             │                                               │
├─────────────┴───────────────────────────────────────────────┤
│ Status Bar (24pt height, optional)                         │
└─────────────────────────────────────────────────────────────┘
```

### 4.4 Responsive Behavior

```
Window Width > 1200pt:
- Sidebar: 280pt expanded
- Canvas: Full width minus sidebar

Window Width 800–1200pt:
- Sidebar: 240pt expanded
- Canvas: Full width minus sidebar

Window Width < 800pt:
- Sidebar: Collapsed (hamburger menu)
- Canvas: Full width
- Mini-map overlay available

Window Height < 600pt:
- Status bar: Hidden
- Toolbar: Compact mode
```

---

## 5. Component Library

### 5.1 Node Components

#### Default Node

```
Container:
- Background: Node Default (see theme)
- Border: 1pt Border Default, 2pt Border Focused when selected
- Corner radius: 8pt
- Shadow: 0pt 2pt 4pt rgba(0,0,0,0.08) (light), rgba(0,0,0,0.3) (dark)

States:
- Default: As described above
- Hover: Background Node Hover, subtle scale(1.01)
- Selected: Border Border Focused, background Node Selected
- Editing: White background, blue border, cursor visible
- Dragging: Shadow elevated (0pt 8pt 16pt), scale(1.02), opacity 0.9
- Collapsed: Italic text, "..." suffix or badge with child count
```

#### Root Node (Central Topic)

```
Container:
- Background: Surface Elevated
- Border: 2pt Accent Primary
- Corner radius: 12pt
- Shadow: 0pt 4pt 12pt rgba(0,0,0,0.12)

Dimensions:
- Minimum width: 120pt
- Padding: 20pt horizontal, 16pt vertical
```

#### Floating Node (for future: free-form positioning)

```
Container:
- Background: Node Default with 0.95 opacity
- Border: 1pt dashed Border Default
- Corner radius: 8pt
- Shadow: 0pt 4pt 8pt rgba(0,0,0,0.1)

Interaction:
- Double-click to create
- Free drag to position
- Snap to grid option (8pt grid)
```

### 5.2 Connection Lines

#### Standard Connection

```
Stroke:
- Width: 2pt
- Color: Connection Line (theme-specific)
- Style: Solid (default), dashed (cross-branch)

Curvature:
- Default: Bezier curve, smooth S-connection
- Orthogonal: Right-angle turns (optional, toggle)

Start/End:
- No decoration (default)
- Arrow head at child end (optional)
- Dot at parent end (optional)
```

#### Selected Connection Path

```
Stroke:
- Width: 3pt
- Color: Accent Primary
- Style: Solid

Animation:
- Pulse effect on selection (subtle glow, 300ms)
```

### 5.3 Toolbar Components

#### Main Toolbar

```
Location: Top of window (standard NSToolbar)
Height: 44pt (standard macOS)
Background: Vibrancy material (NSVisualEffectView)

Items (left to right):
1. New Map Button (SF Symbol: plus.rectangle)
2. Undo/Redo (SF Symbol: arrow.uturn.backward/forward)
3. Separator
4. Node Style Picker (dropdown)
5. Color Picker (8 color swatches)
6. Separator
7. Search Field (width: 200pt, expandable)
8. Separator
9. View Controls (zoom slider, fit-to-screen)
10. Export Button (SF Symbol: square.and.arrow.up)
```

#### Context Menu (Right-Click Node)

```
Style: Standard NSMenu appearance
Items:
- Edit (Enter)
- Add Child (Tab)
- Add Sibling (Enter)
- ---
- Cut (Cmd+X)
- Copy (Cmd+C)
- Paste (Cmd+V)
- Duplicate (Cmd+D)
- ---
- Change Color ▸ (submenu with 8 colors)
- Collapse/Expand (Cmd+Enter)
- ---
- Delete (Delete)

Separator: NSMenuItem separator
```

### 5.4 Sidebar Components

#### Welcome Section

```
Header: "Recent Maps" (Headline style)
Empty State:
- Icon: SF Symbol "brain" or "map"
- Text: "No recent maps"
- Subtext: "Press Cmd+N to create one"

Recent Map Item:
- Height: 48pt
- Thumbnail: 32x32pt preview (rounded 4pt)
- Title: Body style, single line, truncate
- Subtitle: Caption style, last modified date
- Hover: Background Surface Elevated
- Selection: Background Node Selected
```

#### Map List Item

```
Structure:
┌────────────────────────────────────┐
│ [Thumbnail] Title                  │
│            Last modified: date     │
└────────────────────────────────────┘

Thumbnail:
- Size: 40pt x 40pt
- Corner radius: 6pt
- Content: Mini render of mind map (cached)

Hover State:
- Background: Surface Elevated
- Action buttons appear: Open, Delete (subtle)

Selected State:
- Background: Accent Primary at 10% opacity
- Left border: 3pt Accent Primary
```

### 5.5 Overlay Components

#### Search Overlay

```
Trigger: Cmd+F
Position: Top center of canvas
Size: 400pt width, 48pt height
Background: Surface with 0.95 opacity, blur backdrop
Corner radius: 12pt
Shadow: 0pt 8pt 24pt rgba(0,0,0,0.2)

Components:
- Search icon (SF Symbol: magnifyingglass)
- Text field: Body style, no border
- Results count: Caption style, right-aligned
- Close button (Esc): SF Symbol "xmark.circle"

Results:
- Appear below search bar as user types
- Highlight matching text in results
- Navigate with arrow keys, Enter to select
```

#### Keyboard Shortcuts Help

```
Trigger: Press "?" when canvas is focused
Position: Center of screen
Size: 600pt x 400pt (auto-adjusts to content)
Background: Surface with 0.98 opacity, blur backdrop
Corner radius: 16pt
Shadow: 0pt 16pt 48pt rgba(0,0,0,0.3)

Content: Two-column layout
- Left: Category headers (Add, Navigate, Edit, View)
- Right: Shortcut list with key badges

Key Badge Style:
- Background: Surface Elevated
- Border: 1pt Border Default
- Corner radius: 4pt
- Font: SF Pro, 12pt, Medium
- Padding: 4pt 8pt
```

#### Focus Mode Dimmer

```
Behavior: Dims all content except selected branch
Dimmed nodes: 0.2 opacity (configurable)
Selected branch: Full opacity, subtle glow
Transition: 300ms ease-in-out

Indicator:
- Small "Exit Focus" button in corner
- Keyboard hint: "Press Esc to exit focus"
```

### 5.6 Modal Components

#### Export Dialog

```
Style: NSSheet (standard macOS)
Size: 480pt x 360pt
Background: Surface with vibrancy

Options:
- Format: Segmented control (PDF, PNG, Markdown, JSON)
- Quality/Size: Slider or dropdown
- Include: Checkboxes (title, legend, date)
- Theme: Current / Light / Dark

Actions:
- Cancel (Esc): Left button, secondary style
- Export (Cmd+E): Right button, primary style
```

#### Preferences Window

```
Style: Standard NSWindow with tabs
Size: 600pt x 450pt
Tabs: General, Appearance, Shortcuts, Advanced

General:
- Launch behavior: checkbox group
- Auto-save interval: slider (1-10 seconds)
- Recent maps count: stepper (5-50)

Appearance:
- Theme: Visual picker (5 theme swatches)
- Node font: Font picker
- Connection style: Segmented control

Shortcuts:
- Table view with action, shortcut columns
- Click to edit shortcut
- Reset to defaults button

Advanced:
- Canvas performance toggle
- Debug mode checkbox
- Export/Import settings
```

---

## 6. Wireframe Descriptions

### 6.1 Welcome Screen

```
┌─────────────────────────────────────────────────────────────────┐
│ [Window Title: myMindMap]                           [─][□][×] │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│                        myMindMap                                 │
│                                                                  │
│                   ┌──────────────┐                              │
│                   │  + New Map    │                              │
│                   └──────────────┘                              │
│                                                                  │
│    Recent Maps                                    See All →     │
│    ┌─────────┐  ┌─────────┐  ┌─────────┐                        │
│    │ [thumb] │  │ [thumb] │  │ [thumb] │                        │
│    │ Project │  │  Ideas  │  │  Q1     │                        │
│    │ Today   │  │  Week   │  │  Month  │                        │
│    └─────────┘  └─────────┘  └─────────┘                        │
│                                                                  │
│    Templates                                                   │
│    ┌─────────┐  ┌─────────┐  ┌─────────┐                        │
│    │ □ Blank │  │ Project │  │Decision │                        │
│    │         │  │  Plan   │  │  Tree   │                        │
│    └─────────┘  └─────────┘  └─────────┘                        │
│                                                                  │
│         [Cmd+N: New Map]  [?: Shortcuts]                       │
└─────────────────────────────────────────────────────────────────┘
```

**Design Notes:**

- Centered layout with generous white space
- Large, inviting "New Map" button with subtle hover animation
- Recent maps shown as compact cards in a horizontal scroll
- Templates as illustrated icons with labels below
- Keyboard hints at bottom in tertiary text style
- Background: Subtle gradient or soft solid color from theme

### 6.2 Main Editor View

```
┌─────────────────────────────────────────────────────────────────┐
│ [New] [Undo][Redo] │ [Style▼] [Colors] │ [🔍 Search...] │ [Zoom]│
├─────────┬───────────────────────────────────────────────────────┤
│ RECENT  │                                                        │
│         │                                                        │
│ ▶ Proj  │              ○──○──○                                  │
│   Q1    │              │   │   │                                │
│         │              ○   ○   ○                                │
│ ▶ Ideas │              │       │                                │
│   Brain │              ○──○    ○                                │
│         │                         │                              │
│ TEMP-   │              [Selected Node]                         │
│ LATES   │              (editable text)                          │
│         │                                                        │
│         │                                                        │
│─────────│                                                        │
│ [+] New │                                                        │
└─────────┴───────────────────────────────────────────────────────┘
```

**Design Notes:**

- Toolbar: Native macOS toolbar style, icons with labels optional
- Sidebar: 240pt width, collapsible, with section headers
- Canvas: Infinite scroll, pinch-to-zoom, drag-to-pan
- Nodes: Connected with curved bezier lines
- Selected node: Blue border, elevated shadow
- Inline editing: Text field replaces node label on Enter
- Mini-map: Optional overlay in bottom-right corner

### 6.3 Keyboard Navigation State

```
┌─────────────────────────────────────────────────────────────────┐
│ [+][Undo][Redo] │ [Style] [Colors] │ [Search...] │ [Zoom]     │
├─────────┬───────────────────────────────────────────────────────┤
│         │                                                        │
│         │              ○──○──[○]──○                            │
│         │              │   │    ↑   │                           │
│         │              ○   ○    │   ○                           │
│         │              │       [Selected]                        │
│         │              ○──○    │                                │
│         │                         │                              │
│         │           [Tab: Child] [Enter: Sibling]              │
│         │           [↑↓←→: Navigate]  [Delete: Remove]          │
│         │                                                        │
└─────────┴───────────────────────────────────────────────────────┘
```

**Design Notes:**

- Contextual keyboard hints appear below selected node
- Hints are subtle (tertiary text color) and fade after 3 seconds
- Navigation: Arrow keys move between nodes in tree order
- Visual: Selected node has clear focus ring matching accent color

### 6.4 Search Active State

```
┌─────────────────────────────────────────────────────────────────┐
│ [+][Undo][Redo] │ [Style] [Colors] │ [🔍 Search term...      X]│
├─────────┬───────────────────────────────────────────────────────┤
│         │                                                        │
│         │    ┌──────────────────────────────────────┐          │
│         │    │ 🔍 Search term...                   X │          │
│         │    └──────────────────────────────────────┘          │
│         │                                                        │
│         │    Results: 3 matches                                │
│         │    ─────────────────────────────────                  │
│         │    ○ Parent Node > [Match] > Child                   │
│         │    ○ Another > [Match]                                │
│         │    ○ Third > [Match] > Item                          │
│         │                                                        │
│         │              ○──○──○──○                                │
│         │              │   │   │   │                            │
│         │              ○   ○ [○]  ○  ← Highlighted              │
│         │                          │                            │
│         │              [Enter: Next] [Esc: Close]              │
│         │                                                        │
└─────────┴───────────────────────────────────────────────────────┘
```

**Design Notes:**

- Search bar: Floating overlay at top-center
- Results: Dropdown list with highlighted matching text
- Canvas: Matching nodes highlighted with subtle background
- Current result: More prominent highlight (accent color)
- Keyboard: Enter cycles through results, Esc closes

### 6.5 Focus Mode

```
┌─────────────────────────────────────────────────────────────────┐
│ [+][Undo][Redo] │ [Style] [Colors] │ [Search...] │ [Zoom]     │
├─────────┬───────────────────────────────────────────────────────┤
│         │                                                        │
│         │              ○                                         │
│         │              │                                         │
│         │              ○──○──○   ← Full opacity                 │
│         │                  │                                     │
│         │                  [○] ─ Selected branch                 │
│         │                  │                                     │
│         │              ○   ○   ← Dimmed (20% opacity)           │
│         │             /│\  │                                    │
│         │            ○ ○ ○ ○                                   │
│         │                                                        │
│         │        [Exit Focus: Esc]                               │
│         │                                                        │
└─────────┴───────────────────────────────────────────────────────┘
```

**Design Notes:**

- Selected branch: Full opacity, subtle glow effect
- Non-selected content: Dimmed to 20% opacity
- Transition: Smooth 300ms fade
- Exit hint: Persistent but subtle in corner

### 6.6 Export Dialog

```
┌─────────────────────────────────────────────────────────────────┐
│                        Export Map                               │
│                                                                 │
│    Format                                                         │
│    ┌───────┬────────┬──────────┬───────┐                        │
│    │  PDF  │  PNG   │ Markdown │ JSON  │                        │
│    └───────┴────────┴──────────┴───────┘                        │
│                                                                 │
│    Options                                                       │
│    ┌────────────────────────────────────────┐                   │
│    │ ☑ Include title                        │                   │
│    │ ☑ Include timestamp                    │                   │
│    │ ○ Current zoom level                   │                   │
│    │ ● Fit entire map                       │                   │
│    └────────────────────────────────────────┘                   │
│                                                                 │
│    Theme                                                         │
│    ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐                     │
│    │ ☀   │ │ 🌙  │ │ 🌊  │ │ 🌲  │ │ 🌅  │                     │
│    └─────┘ └─────┘ └─────┘ └─────┘ └─────┘                     │
│                                                                 │
│                    [Cancel]  [Export]                           │
└─────────────────────────────────────────────────────────────────┘
```

**Design Notes:**

- Style: macOS sheet with standard toolbar
- Format selector: Segmented control, prominent
- Options: Standard checkboxes and radio buttons
- Theme preview: Live preview updates as theme is selected
- Actions: Cancel (left, secondary), Export (right, primary)

---

## 7. Animation Specifications

### 7.1 Animation Principles

- **Duration:** 200-300ms for standard transitions
- **Easing:** Use spring animations for natural feel
- **Performance:** Maintain 60fps, use GPU acceleration
- **Purpose:** Guide attention, not distract

### 7.2 Timing Functions

```swift
// SwiftUI animation modifiers to use:

// Quick, subtle (hover states)
.animation(.easeInOut(duration: 0.15), value: isHovered)

// Standard transitions
.animation(.easeInOut(duration: 0.25), value: state)

// Spring animations (recommended for most interactions)
.animation(.spring(response: 0.3, dampingFraction: 0.7), value: position)
.animation(.spring(response: 0.35, dampingFraction: 0.8), value: scale)

// Slower, deliberate (focus changes)
.animation(.easeInOut(duration: 0.35), value: focusState)
```

### 7.3 Node Animations

#### Node Selection

```
Trigger: Node becomes selected
Animation:
  - Scale: 1.0 → 1.02 → 1.0 (spring, 200ms)
  - Border: Fade in border color (150ms)
  - Shadow: Elevate shadow (200ms)
  - Background: Cross-fade to selected color (150ms)
```

#### Node Creation

```
Trigger: New node added (Tab or Enter)
Animation:
  - Scale: 0.8 → 1.0 (spring, 250ms)
  - Opacity: 0 → 1 (ease-out, 150ms)
  - Position: Slide in from parent (200ms)
  - Focus: Automatically moves to new node
```

#### Node Deletion

```
Trigger: Delete key pressed
Animation:
  - Scale: 1.0 → 0.95 (100ms)
  - Opacity: 1.0 → 0 (150ms)
  - Position: Collapse toward parent (200ms)
  - Siblings: Smoothly re-position (spring, 250ms)
```

#### Node Drag

```
Trigger: Mouse drag initiated
Animation:
  - Shadow: Elevate immediately
  - Scale: 1.0 → 1.02 (spring, 150ms)
  - Opacity: 1.0 → 0.9 (immediate)

Drop:
  - Scale: 1.02 → 1.0 (spring, 200ms)
  - Shadow: Reduce to default (150ms)
  - Position: Settle with subtle bounce
```

#### Collapse/Expand

```
Trigger: Cmd+Enter toggles collapse
Animation (Collapse):
  - Children: Fade out and scale down (200ms)
  - Badge: Fade in showing child count (150ms)
  - Connection: Shorten smoothly (200ms)

Animation (Expand):
  - Badge: Fade out (100ms)
  - Children: Fade in and scale up (250ms)
  - Connection: Extend smoothly (200ms)
```

### 7.4 Canvas Animations

#### Pan (Scroll)

```
Implementation: Native NSScrollView/ScrollView
Feel: Direct 1:1 tracking, no animation
Momentum: System momentum scrolling (native feel)
```

#### Zoom

```
Trigger: Cmd+/, pinch, or scroll wheel
Animation:
  - Duration: 200ms
  - Easing: easeInOut
  - Focus: Zoom toward cursor position
  - Scale range: 10% to 400%
```

#### Fit to Screen

```
Trigger: Cmd+0
Animation:
  - Duration: 350ms
  - Easing: spring(response: 0.4, dampingFraction: 0.8)
  - End state: All nodes visible with 48pt padding
```

### 7.5 UI Overlay Animations

#### Search Overlay

```
Open (Cmd+F):
  - Duration: 200ms
  - Scale: 0.95 → 1.0 (spring)
  - Opacity: 0 → 1
  - Position: Slide down 8pt → 0

Close (Esc):
  - Duration: 150ms
  - Scale: 1.0 → 0.98
  - Opacity: 1 → 0

Results appear:
  - Stagger: 30ms delay per result
  - Animation: Slide in from right (150ms each)
```

#### Keyboard Shortcuts Help

```
Open (? key):
  - Duration: 250ms
  - Scale: 0.9 → 1.0 (spring)
  - Opacity: 0 → 1
  - Backdrop: Fade in blur (200ms)

Close:
  - Duration: 150ms
  - Scale: 1.0 → 1.02
  - Opacity: 1 → 0
```

#### Focus Mode Transition

```
Enter:
  - Duration: 300ms
  - Non-selected: Fade to 20% opacity (ease-in-out)
  - Selected: Subtle pulse/glow (once)

Exit:
  - Duration: 250ms
  - All: Fade to 100% opacity (ease-out)
  - Glow: Fade out
```

### 7.6 Transition Animations

#### View Transitions

```
Sidebar collapse/expand:
  - Duration: 250ms
  - Easing: easeInOut
  - Canvas: Resize smoothly

Welcome → Editor:
  - Duration: 300ms
  - Effect: Cross-fade with subtle scale
  - Direction: Content slides up, new content fades in
```

#### Theme Switch

```
Trigger: User selects new theme
Animation:
  - Duration: 400ms (deliberate, satisfying)
  - Effect: All colors cross-fade simultaneously
  - Canvas: Brief subtle scale (1.0 → 1.005 → 1.0)
  - Note: Nodes maintain position during transition
```

---

## 8. macOS-Specific Elements

### 8.1 Window Structure

#### Main Window (NSWindow)

```
Style: NSWindow.StyleMask [titled, closable, miniaturizable, resizable]
Title bar: Unified with toolbar (NSWindow.StyleMask.fullSizeContentView)
Minimum size: 800pt x 600pt
Default size: 1200pt x 800pt
Title visibility: Hidden (toolbar shows document name)
Toolbar: Yes (standard NSToolbar)

Window behavior:
- Remember position and size between sessions
- Support split view (two windows side by side)
- Support full screen mode
- Support multiple spaces
```

#### Preferences Window (NSWindow)

```
Style: Standard preferences window
Size: 600pt x 450pt (fixed)
Tabs: NSTabView with 4 tabs
Position: Center on screen
```

### 8.2 Toolbar (NSToolbar)

```
Identifier: "MainToolbar"
Display mode: Icon and label (default), icon only (compact)
Allows customization: Yes (standard macOS behavior)

Default items:
- Item 1: "NewMap" - SF Symbol "plus.rectangle" - Cmd+N
- Item 2: "Undo" - SF Symbol "arrow.uturn.backward" - Cmd+Z
- Item 3: "Redo" - SF Symbol "arrow.uturn.forward" - Cmd+Shift+Z
- Flexible space
- Item 4: "StylePicker" - Custom view (node style dropdown)
- Item 5: "ColorPicker" - Custom view (color swatches)
- Flexible space
- Item 6: "Search" - NSSearchField - Cmd+F
- Item 7: "Zoom" - Custom view (zoom slider + fit button)
- Item 8: "Export" - SF Symbol "square.and.arrow.up" - Cmd+E
```

### 8.3 Menu Bar Structure

#### Application Menu (myMindMap)

```
About myMindMap
---
Preferences... - Cmd+,
---
Services ▸
---
Hide myMindMap - Cmd+H
Hide Others - Cmd+Opt+H
Show All
---
Quit myMindMap - Cmd+Q
```

#### File Menu

```
New Map - Cmd+N
New Map from Template ▸
  - Blank Map
  - Project Plan
  - Brainstorm
  - Decision Tree
  ---
  (separator)
Open... - Cmd+O
Open Recent ▸
  - [list of recent maps]
  - Clear Menu
---
Close - Cmd+W
---
Save - Cmd+S
Save As... - Cmd+Shift+S
Duplicate - Cmd+D
---
Export ▸
  - Export as PDF...
  - Export as PNG...
  - Export as Markdown...
  - Export as JSON...
```

#### Edit Menu

```
Undo [Action] - Cmd+Z
Redo [Action] - Cmd+Shift+Z
---
Cut - Cmd+X
Copy - Cmd+C
Paste - Cmd+V
Delete - Backspace
Select All - Cmd+A
---
Find ▸
  - Find... - Cmd+F
  - Find Next - Cmd+G
  - Find Previous - Cmd+Shift+G
```

#### Format Menu

```
Add ▸
  - Child Node - Tab
  - Sibling Node - Enter
  - Parent Node - Cmd+Enter
---
Organize ▸
  - Move Up - Cmd+Up
  - Move Down - Cmd+Down
  - Move Left - Cmd+Left
  - Move Right - Cmd+Right
  - ---
  - Collapse - Cmd+Enter
  - Expand - Cmd+Enter
  - Collapse All - Cmd+Shift+Enter
  - Expand All - Cmd+Opt+Enter
---
Style ▸
  - Node Colors (submenu with 8 colors)
  - Node Styles (submenu)
```

#### View Menu

```
Zoom ▸
  - Zoom In - Cmd++
  - Zoom Out - Cmd+-
  - Actual Size - Cmd+0
  - Fit to Screen - Cmd+1
  ---
  - Enter Full Screen - Cmd+Ctrl+F
---
Focus Mode - Cmd+Shift+F
Show Mini Map - Cmd+M
Show Sidebar - Cmd+Opt+S
---
Show Keyboard Shortcuts - ?
```

#### Window Menu

```
Minimize - Cmd+M
Zoom
---
Bring All to Front
```

#### Help Menu

```
myMindMap Help
  - Search: ? (when app is focused)
---
Release Notes
---
Contact Support
```

### 8.4 Keyboard Shortcuts Reference

| Action | Shortcut | Context |
|--------|----------|---------|
| New Map | Cmd+N | Global |
| New Child Node | Tab | Canvas |
| New Sibling Node | Enter | Canvas |
| Edit Node | Enter / Double-click | Canvas |
| Delete Node | Delete / Backspace | Canvas |
| Save | Cmd+S | Global |
| Undo | Cmd+Z | Global |
| Redo | Cmd+Shift+Z | Global |
| Find | Cmd+F | Global |
| Zoom In | Cmd++ | Canvas |
| Zoom Out | Cmd+- | Canvas |
| Fit to Screen | Cmd+0 | Canvas |
| Focus Mode | Cmd+Shift+F | Canvas |
| Toggle Sidebar | Cmd+Opt+S | Global |
| Collapse/Expand | Cmd+Enter | Canvas |
| Copy | Cmd+C | Canvas |
| Paste | Cmd+V | Canvas |
| Cut | Cmd+X | Canvas |
| Show Shortcuts | ? | Canvas |
| Close | Cmd+W | Global |
| Quit | Cmd+Q | Global |

### 8.5 Contextual Menu

Right-click on canvas or node to show:

```
[When right-clicking canvas (empty area):]
- New Map (Cmd+N)
- Paste (Cmd+V)
- ---
- Zoom to Fit (Cmd+0)
- ---
- Show Keyboard Shortcuts (?)

[When right-clicking node:]
- Edit (Enter)
- Add Child (Tab)
- Add Sibling (Enter)
- ---
- Cut (Cmd+X)
- Copy (Cmd+C)
- Paste (Cmd+V)
- Duplicate (Cmd+D)
- Delete (Backspace)
- ---
- Change Color ▸ (submenu)
- Change Style ▸ (submenu)
- ---
- Collapse/Expand (Cmd+Enter)
- Collapse All Children
- Expand All Children
```

### 8.6 Touch Bar (if applicable)

```
[For MacBooks with Touch Bar:]

Left:
- New Node (Tab icon)
- Delete (trash icon)

Center:
- [Node text display / edit field when editing]

Right:
- Color Picker (8 color circles)
- Undo/Redo
```

### 8.7 Keyboard Focus Indicators

```
Focus ring:
- Color: Accent Primary
- Width: 3pt
- Style: Rounded rectangle (matches node corner radius)
- Animation: Subtle pulse on initial focus (150ms)

Focus order:
1. Toolbar
2. Canvas (nodes)
3. Sidebar (if focused)
4. Overlays (search, shortcuts)

Tab navigation: Follows focus order above
Shift+Tab: Reverse focus order
```

### 8.8 Accessibility

```
VoiceOver support:
- All nodes announce: "Node: [text], level [n], [collapsed/expanded]"
- Selected node: "Selected, [text]"
- Actions available: "Actions: Edit, Add child, Delete"

Keyboard navigation:
- Full keyboard accessibility for all features
- No mouse required for any operation
- Clear focus indicators at all times

High contrast:
- Support macOS Increased Contrast accessibility setting
- Override colors when accessibility is enabled
- Ensure 4.5:1 contrast ratio minimum for text
```

---

## Appendix: Implementation Notes

### SwiftUI Implementation

```swift
// Color palette example
extension Color {
    static let nodeDefault = Color("NodeDefault")
    static let nodeSelected = Color("NodeSelected")
    static let accentPrimary = Color("AccentPrimary")
    // ... etc
}

// Theme manager
@Environment(\.colorScheme) var colorScheme
@AppStorage("selectedTheme") var selectedTheme: Theme = .light
```

### Asset Requirements

```
App Icon:
- Sizes: 16, 32, 64, 128, 256, 512, 1024 (all @1x and @2x)
- Design: Stylized brain/map icon
- Style: Matches selected theme aesthetic

SF Symbols used:
- plus.rectangle
- arrow.uturn.backward
- arrow.uturn.forward
- magnifyingglass
- square.and.arrow.up
- trash
- pencil
- chevron.right
- chevron.down
- sidebar.left
- keyboard
- moon.fill
- sun.max.fill
- leaf.fill
- water.waves
```

---

*Document Version: 1.0*
*Status: Ready for Engineering Review*
*Next Step: Engineering feasibility review and implementation planning*
