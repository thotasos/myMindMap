# Product Requirements Document (PRD)

## myMindMap — Minimalist macOS Mind Mapping Application

**Version:** 1.0
**Date:** 2026-03-10
**Status:** Draft
**Owner:** Product Management

---

## 1. Product Vision and Positioning

### 1.1 Vision Statement

myMindMap is a minimalist, keyboard-driven mind mapping application designed for productivity-focused professionals who value frictionless workflows and native macOS experiences. It empowers users to capture, organize, and visualize ideas rapidly without the cognitive overhead of complex tooling.

### 1.2 Problem Statement

- **Problem 1:** Existing mind mapping tools are either too simplistic (lack advanced features) or overwhelmingly complex (steep learning curves, cluttered interfaces).
- **Problem 2:** Professionals who prefer keyboard-driven workflows find most mind mapping apps mouse-dependent, breaking their flow state.
- **Problem 3:** Many tools lack native macOS integration, resulting in disconnected experiences from the Apple ecosystem.

### 1.3 Target Audience

| Attribute | Detail |
|-----------|--------|
| **Primary Audience** | Productivity-focused professionals, ages 25-40 |
| **Secondary Audience** | Students, researchers, writers, and strategists |
| **Tech Proficiency** | Comfortable with keyboard shortcuts, appreciates native app quality |
| **Use Cases** | Project planning, brainstorming, note-taking, decision-making, documentation |

### 1.4 Value Proposition

> "Capture and organize your thoughts at the speed of ideas with a mind mapping tool that feels like a natural extension of your mind."

**Key Differentiators:**
- **Keyboard-First Design:** Every action achievable via keyboard shortcuts
- **Minimalist Aesthetic:** Distraction-free interface that puts content first
- **Native macOS Feel:** Seamless integration with macOS conventions, design language, and system features
- **Frictionless UX:** Instant response times, no modal dialogs for common actions, fluid animations

### 1.5 Competitive Positioning

| Competitor | Strength | myMindMap Advantage |
|------------|----------|---------------------|
| MindNode | Beautiful design | Faster keyboard workflows, lighter weight |
| XMind | Feature-rich | Simpler, more focused, better keyboard support |
| Miro | Collaboration | Offline-first, native app performance |
| Obsidian (with plugins) | Extensible | Purpose-built for mind mapping, smoother UX |

---

## 2. Core Feature Set

### 2.1 Mind Map Creation

- **Quick Start:** Create a new mind map instantly with a single keystroke (Cmd+N)
- **Central Node:** Auto-generated root node with customizable title
- **Templates:** Pre-built templates for common use cases (project plan, brainstorm, decision tree)
- **Canvas:** Infinite canvas with pan and zoom navigation

### 2.2 Node Editing

- **Inline Editing:** Double-click or press Enter to edit node text inline
- **Rich Text:** Basic formatting (bold, italic, bullet points) within nodes
- **Node Types:** Support for text nodes, with placeholder for future types (images, links)
- **Auto-save:** All changes saved automatically to local storage

### 2.3 Node Organization

- **Add Child Node:** Tab key to add child to selected node
- **Add Sibling Node:** Enter key to add sibling node
- **Move Nodes:** Drag-and-drop or keyboard shortcuts to reorder
- **Collapse/Expand:** Collapse subtrees to reduce visual clutter
- **Delete Node:** Delete or Backspace key to remove nodes

### 2.4 Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| New Mind Map | Cmd+N |
| Save | Cmd+S (auto-save enabled, but manual save available) |
| New Node (child) | Tab |
| New Node (sibling) | Enter |
| Edit Node | Enter / Double-click |
| Delete Node | Delete / Backspace |
| Move Node Up | Cmd+Up |
| Move Node Down | Cmd+Down |
| Collapse/Expand | Cmd+Enter |
| Zoom In | Cmd++ |
| Zoom Out | Cmd+- |
| Fit to Screen | Cmd+0 |
| Search | Cmd+F |
| Undo | Cmd+Z |
| Redo | Cmd+Shift+Z |

### 2.5 Navigation and View

- **Pan:** Click and drag canvas, or use trackpad/mouse gestures
- **Zoom:** Pinch gesture, scroll wheel, or keyboard shortcuts
- **Focus Mode:** Dim all nodes except selected branch
- **Mini Map:** Optional overview panel for large mind maps

### 2.6 Export and Integration

- **Export Formats:** PDF, PNG, Markdown, JSON
- **Import:** Import from JSON, Markdown outlines
- **Copy:** Copy selected subtree as Markdown to clipboard

### 2.7 Persistence and Storage

- **Local Storage:** All mind maps stored locally using SQLite
- **Recent Files:** Quick access to recently opened mind maps
- **File Management:** Standard macOS file picker for export/import

---

## 3. User Stories

### 3.1 Mind Map Creation

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-001 | As a user, I want to create a new mind map with a single keystroke so that I can start capturing ideas immediately. | Pressing Cmd+N creates a new mind map with a default root node. User can immediately type to rename the root node. |
| US-002 | As a user, I want to start from a template so that I don't have to structure common mind maps from scratch. | User can select from at least 3 templates (Blank, Project Plan, Brainstorm). Templates pre-populate nodes with placeholder content. |

### 3.2 Node Editing

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-003 | As a user, I want to edit node text by simply typing when the node is selected, so that I can quickly capture my thoughts. | Selecting a node and typing replaces the node text. No extra clicks or dialogs required. Pressing Escape cancels edit. |
| US-004 | As a user, I want to add child and sibling nodes using keyboard shortcuts so that I never need to reach for the mouse. | Pressing Tab adds a child node. Pressing Enter adds a sibling node. Focus automatically moves to the new node for immediate typing. |
| US-005 | As a user, I want to delete nodes with a single keystroke so that I can iterate quickly on my structure. | Pressing Delete removes the selected node and all its children. Undo (Cmd+Z) can restore deleted nodes. |

### 3.3 Navigation

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-006 | As a user, I want to zoom and pan the canvas smoothly so that I can navigate large mind maps without frustration. | Zoom in/out works via Cmd+/-, trackpad pinch, and scroll wheel. Pan works via trackpad drag or clicking and dragging on empty canvas. Animations are smooth (60fps). |
| US-007 | As a user, I want to collapse and expand branches so that I can focus on relevant sections of my mind map. | Pressing Cmd+Enter toggles collapse/expand on the selected node. Collapsed nodes show a visual indicator (ellipsis or badge). |

### 3.4 Persistence

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-008 | As a user, I want my mind maps to auto-save so that I never lose work even if I forget to save manually. | Changes are saved automatically within 1 second of editing. No explicit save action required. App reopens to the last state. |
| US-009 | As a user, I want to see my recently opened mind maps so that I can resume work quickly. | A "Recent" section shows the last 10 opened mind maps with timestamps. Clicking opens the map instantly. |

### 3.5 Export

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-010 | As a user, I want to export my mind map to PDF and PNG so that I can share it with others who don't use the app. | Export dialog allows selecting format (PDF/PNG). Export respects current zoom level or offers full map option. |
| US-011 | As a user, I want to copy my mind map structure as Markdown so that I can paste it into notes, docs, or code. | Selecting a node and pressing Cmd+Shift+C copies that node and all descendants as Markdown outline to clipboard. |

### 3.6 Search

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-012 | As a user, I want to search for text across my mind map so that I can quickly find specific ideas. | Pressing Cmd+F opens a search overlay. Typing filters nodes in real-time. Enter moves to next match. Esc closes search. |

---

## 4. Success Metrics and KPIs

### 4.1 User Acquisition Metrics

| Metric | Target (Launch) | Target (6 months) |
|--------|-----------------|-------------------|
| Downloads | 1,000 | 10,000 |
| MAU (Monthly Active Users) | 500 | 5,000 |
| Activation Rate (users who create 1+ map) | >60% | >70% |

### 4.2 Engagement Metrics

| Metric | Target (Launch) | Target (6 months) |
|--------|-----------------|-------------------|
| DAU/MAU Ratio | 30% | 40% |
| Average Session Duration | 10 min | 15 min |
| Maps Created per User (monthly) | 3 | 5 |
| Keyboard Shortcut Usage Rate | 50% | 65% |

### 4.3 Retention Metrics

| Metric | Target (Launch) | Target (6 months) |
|--------|-----------------|-------------------|
| Day 1 Retention | 40% | 50% |
| Day 7 Retention | 25% | 35% |
| Day 30 Retention | 15% | 25% |

### 4.4 Performance Metrics

| Metric | Target |
|--------|--------|
| App Launch Time | <1 second |
| Node Creation Latency | <50ms |
| Auto-save Latency | <100ms |
| Canvas Render (1000 nodes) | 60fps |
| Memory Usage (idle) | <100MB |
| Export PDF (100 nodes) | <3 seconds |

### 4.5 Quality Metrics

| Metric | Target |
|--------|--------|
| Crash Rate | <0.5% |
| Bug Report Volume | <10 critical/month |
| App Store Rating | 4.5+ |
| Keyboard Shortcut Accessibility | 100% coverage for core actions |

---

## 5. Feature Prioritization

### 5.1 MVP (Minimum Viable Product) — Release 1.0

**Target Ship Date:** 90 days from project start

| Feature | Priority | Description |
|---------|----------|-------------|
| Mind Map Creation | P0 | Create new maps, root node, basic canvas |
| Node Editing | P0 | Inline text editing, basic formatting |
| Node Organization | P0 | Add child/sibling, delete, move |
| Keyboard Navigation | P0 | All core shortcuts (Tab, Enter, Delete, arrows) |
| Auto-save | P0 | Background persistence to SQLite |
| Zoom/Pan | P0 | Canvas navigation, fit-to-screen |
| Recent Files | P1 | Quick access to last 10 maps |
| Export PDF | P1 | Basic PDF export |
| Undo/Redo | P1 | Action history stack |

**MVP Scope Boundaries:**
- Single-window application (no tabs)
- Local storage only (no iCloud sync)
- PNG export only (no PDF in MVP, moved to 1.1)
- No collaboration features
- No iOS companion app
- Basic visual styling (no theme customization)

### 5.2 Release 1.1 — Enhanced Export & Organization

**Target:** 30 days post-MVP

| Feature | Priority | Description |
|---------|----------|-------------|
| Export PDF | P0 | Full PDF export with layout options |
| Export PNG | P0 | High-resolution image export |
| Collapse/Expand | P0 | Toggle node visibility |
| Search | P0 | Full-text search across map |
| Copy as Markdown | P1 | Export subtree to clipboard |

### 5.3 Release 1.2 — Organization & Templates

**Target:** 60 days post-MVP

| Feature | Priority | Description |
|---------|----------|-------------|
| Templates | P0 | Pre-built templates (Project, Brainstorm, etc.) |
| Folder Organization | P1 | Group maps into folders |
| Mini Map | P2 | Overview panel for large maps |
| Focus Mode | P2 | Dim non-focused branches |

### 5.4 Release 2.0 — Polish & Scale

**Target:** 120 days post-MVP

| Feature | Priority | Description |
|---------|----------|-------------|
| Custom Themes | P1 | Color schemes, node styling |
| iCloud Sync | P1 | Cross-device persistence |
| Keyboard Shortcut Customization | P2 | User-configurable shortcuts |
| Node Colors | P2 | Color-code nodes by category |

### 5.5 Future Considerations (Backlog)

| Feature | Priority | Description |
|---------|----------|-------------|
| Collaboration | P3 | Shared maps, real-time editing |
| iOS App | P3 | Native iPad/iPhone companion |
| Voice Input | P4 | Dictation for node text |
| AI Integration | P4 | Auto-generate structure from text |
| Presentation Mode | P4 | Full-screen slideshow |

---

## 6. Non-Functional Requirements

### 6.1 Performance

- App must launch in under 1 second on MacBook Air (M1)
- All UI interactions must respond in under 50ms
- Canvas must maintain 60fps with 500+ nodes visible

### 6.2 Accessibility

- Full VoiceOver support for all interactive elements
- Keyboard navigation for all features (no mouse required)
- High contrast mode support

### 6.3 Security

- No data leaves the device unless explicitly exported
- App Sandbox enabled for App Store distribution
- No third-party analytics in MVP (opt-in in future)

### 6.4 Compatibility

- Supports macOS 13.0 (Ventura) and later
- Universal binary (Intel and Apple Silicon)
- Retina display support

---

## 7. Risks and Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Scope creep due to "keyboard-first" complexity | High | Strict feature freeze for MVP; all new ideas go to backlog |
| Performance degradation with large maps | Medium | Implement viewport culling; test with 1000+ nodes early |
| Competition from established tools | Medium | Focus on keyboard-first differentiator; aggressive performance optimization |
| App Store review delays | Medium | Submit for beta testing early; maintain clean, compliant codebase |

---

## 8. Appendix

### 8.1 Glossary

| Term | Definition |
|------|------------|
| **Node** | A single element in the mind map containing text |
| **Root Node** | The central/topmost node of a mind map |
| **Child Node** | A node connected below its parent |
| **Sibling Node** | A node at the same level as another, sharing a parent |
| **Canvas** | The infinite scrollable area containing the mind map |
| **Auto-save** | Automatic background saving without user action |

### 8.2 Design Principles

1. **Keyboard First:** Every feature must be accessible without leaving the keyboard.
2. **Instant Gratification:** No waiting, no loading, no modal dialogs for common actions.
3. **Native Feel:** Follow macOS Human Interface Guidelines precisely.
4. **Progressive Disclosure:** Show simple interface initially; advanced features available but unobtrusive.
5. **Respect User Time:** Minimize clicks, maximize flow.

---

*Document Status: Draft for Team Review*
*Next Step: Engineering feasibility review and sprint planning*
