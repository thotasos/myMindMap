# Project Plan: myMindMap

**Project**: myMindMap - Minimalist macOS Mind Mapping Application
**Version**: 1.0
**Date**: 2026-03-10
**Status**: Draft

---

## 1. Project Overview

### Assumptions
- Team size: 1-2 Swift/SwiftUI developers
- Target audience: Productivity-focused professionals, ages 25-40
- Core requirement: Must work offline
- MVP scope: Core mind mapping functionality with keyboard-first navigation
- Timeline: 8-12 weeks to MVP

### High-Level Timeline

| Milestone | Duration | Target Date | Deliverable |
|-----------|----------|-------------|-------------|
| **Sprint 1** | 2 weeks | Week 1-2 | Project Setup & Core Architecture |
| **Sprint 2** | 2 weeks | Week 3-4 | Node Creation & Basic Editing |
| **Sprint 3** | 2 weeks | Week 5-6 | Connections & Layout Engine |
| **Sprint 4** | 2 weeks | Week 7-8 | Keyboard Shortcuts & Navigation |
| **Sprint 5** | 2 weeks | Week 9-10 | Export, Persistence & Polish |
| **Sprint 6** (buffer) | 2 weeks | Week 11-12 | Bug Fixes, Performance, Release Prep |

**Total Estimated Timeline**: 10-12 weeks (with 2-week buffer)

---

## 2. Sprint Breakdown

### Sprint 1: Project Setup & Core Architecture
**Duration**: 2 weeks
**Goal**: Foundation for the application

| Task | Description | Estimated Effort |
|------|-------------|------------------|
| 1.1 | XcodeGen project setup with SwiftUI target | 2 days |
| 1.2 | SwiftData model design (MindMap, Node, Connection) | 3 days |
| 1.3 | App lifecycle & window management | 2 days |
| 1.4 | Canvas view foundation with pan/zoom | 3 days |
| 1.5 | Basic navigation structure | 2 days |
| 1.6 | LocalStorage/CloudKit sync infrastructure | 3 days |

**Go/No-Go Criteria**:
- [ ] Project compiles without errors
- [ ] SwiftData models defined and migratable
- [ ] Canvas displays and responds to pan/zoom gestures
- [ ] Window opens with empty canvas state

---

### Sprint 2: Node Creation & Basic Editing
**Duration**: 2 weeks
**Goal**: Core node manipulation

| Task | Description | Estimated Effort |
|------|-------------|------------------|
| 2.1 | Node model with text, color, position | 2 days |
| 2.2 | Node view rendering on canvas | 2 days |
| 2.3 | Double-click to create new node | 2 days |
| 2.4 | Text editing within nodes | 3 days |
| 2.5 | Node selection and multi-selection | 3 days |
| 2.6 | Node deletion and duplication | 2 days |

**Go/No-Go Criteria**:
- [ ] Users can create nodes by double-clicking canvas
- [ ] Nodes display text and are editable inline
- [ ] Single and multi-node selection works
- [ ] Nodes can be deleted and duplicated
- [ ] Undo/Redo support for node operations

---

### Sprint 3: Connections & Layout Engine
**Duration**: 2 weeks
**Goal**: Node relationships and intelligent layouts

| Task | Description | Estimated Effort |
|------|-------------|------------------|
| 3.1 | Connection model (source, target, style) | 2 days |
| 3.2 | Bezier curve connection rendering | 3 days |
| 3.3 | Drag-to-connect node linking | 3 days |
| 3.4 | Auto-layout algorithm (tree/radial) | 4 days |
| 3.5 | Connection styling (colors, arrows) | 2 days |
| 3.6 | Delete connections | 1 day |

**Go/No-Go Criteria**:
- [ ] Nodes can be connected by dragging between them
- [ ] Connections render as smooth bezier curves
- [ ] Auto-layout arranges nodes logically
- [ ] Connections can be styled and deleted
- [ ] Root node concept established

---

### Sprint 4: Keyboard Shortcuts & Navigation
**Duration**: 2 weeks
**Goal**: Keyboard-first interaction model

| Task | Description | Estimated Effort |
|------|-------------|------------------|
| 4.1 | Global keyboard shortcut system | 2 days |
| 4.2 | Arrow key navigation between nodes | 2 days |
| 4.3 | Tab/Shift+Tab to navigate connections | 2 days |
| 4.4 | Command+N (new node), Command+D (duplicate) | 2 days |
| 4.5 | Command+Delete (delete node) | 1 day |
| 4.6 | Enter to edit selected node | 1 day |
| 4.7 | Escape to deselect / cancel edit | 1 day |
| 4.8 | Command+S (save), Command+Z (undo) | 2 days |

**Go/No-Go Criteria**:
- [ ] All core operations accessible via keyboard
- [ ] Arrow key navigation follows visual connection flow
- [ ] Keyboard shortcuts work when canvas is focused
- [ ] No mouse required for basic mind mapping workflow

---

### Sprint 5: Export, Persistence & Polish
**Duration**: 2 weeks
**Goal**: Data management and final touches

| Task | Description | Estimated Effort |
|------|-------------|------------------|
| 5.1 | Auto-save with SwiftData | 2 days |
| 5.2 | Recent documents menu | 1 day |
| 5.3 | Export to JSON | 2 days |
| 5.4 | Export to Markdown/OPML | 2 days |
| 5.5 | Export to PNG/PDF | 2 days |
| 5.6 | Visual polish (animations, transitions) | 3 days |
| 5.7 | Theme support (light/dark) | 2 days |

**Go/No-Go Criteria**:
- [ ] Documents auto-save seamlessly
- [ ] All export formats generate valid output
- [ ] Animations are smooth (60fps)
- [ ] Light and dark modes display correctly

---

### Sprint 6: Release Preparation
**Duration**: 2 weeks (buffer)
**Goal**: Bug fixes and release readiness

| Task | Description | Estimated Effort |
|------|-------------|------------------|
| 6.1 | Performance optimization | 3 days |
| 6.2 | Memory leak fixes | 2 days |
| 6.3 | Edge case testing | 3 days |
| 6.4 | App Store metadata preparation | 2 days |
| 6.5 | Build and test archive | 2 days |
| 6.6 | Final polish and bug fixes | 3 days |

**Go/No-Go Criteria**:
- [ ] No critical or blocker bugs
- [ ] Performance: 1000+ nodes at 60fps
- [ ] App passes App Store review guidelines
- [ ] Build archive validates successfully

---

## 3. Risk Assessment & Mitigation

| Risk | Likelihood | Impact | Mitigation Strategy |
|------|------------|--------|---------------------|
| **Complex layout algorithm** | Medium | High | Start with simple layout; add intelligent layouts in v1.1 |
| **Performance at scale** | High | Medium | Early prototyping with 500+ nodes; optimize rendering |
| **Keyboard accessibility gaps** | Medium | Medium | Design keyboard-first from Sprint 1; test with accessibility audit |
| **SwiftData migration issues** | Low | High | Version models carefully; use lightweight migration |
| **Scope creep** | High | High | Strict MVP boundaries; defer features to post-MVP |
| **macOS compatibility** | Low | Medium | Test on macOS 13+ minimum; use standard SwiftUI components |
| **Export format edge cases** | Medium | Low | Prioritize JSON/Markdown; defer PDF to v1.1 |

### Risk Response Priorities
1. **Scope Creep**: Enforce MVP feature freeze after Sprint 2
2. **Performance**: Build performance tests in Sprint 2-3
3. **Keyboard UX**: Include QA checks every sprint

---

## 4. Resource Needs

### Team
| Role | FTE | Notes |
|------|-----|-------|
| Swift/SwiftUI Developer | 1.0 | Primary implementation |
| QA Engineer (optional) | 0.2 | Part-time testing |

### Infrastructure
| Resource | Need |
|----------|------|
| macOS Development Machine | 1 |
| Xcode 15+ | Latest |
| Apple Developer Account | Required for distribution |
| TestFlight (optional) | For beta testing |

### Dependencies (Estimated)
- No external dependencies for core MVP
- Consider: None required at MVP

---

## 5. Dependencies & Blockers

### External Dependencies
| Dependency | Status | Notes |
|------------|--------|-------|
| XcodeGen | Required | Project generation |
| Apple Developer Program | Required | For App Store distribution |

### Internal Dependencies
| From | To | Dependency |
|------|-----|------------|
| Sprint 1 | Sprint 2 | Canvas foundation required for node work |
| Sprint 2 | Sprint 3 | Node model required for connections |
| Sprint 3 | Sprint 4 | Connections needed for keyboard nav |
| Sprint 1-4 | Sprint 5 | All features needed for export |

### Blocker Prevention
- Complete Sprint 1 before Sprint 2 begins
- Buffer time between sprints for integration issues
- Daily sync to catch blockers early

---

## 6. Go/No-Go Decision Points

### Milestone 1: Sprint 2 Complete (Week 4)
- **Go Criteria**: Basic node creation and editing functional
- **No-Go**: Major rendering issues or data model instability

### Milestone 2: Sprint 4 Complete (Week 8)
- **Go Criteria**: All keyboard shortcuts implemented and tested
- **No-Go**: Any core operation requires mouse

### Milestone 3: Sprint 6 Complete (Week 12)
- **Go Criteria**: Release-ready build with < 3 minor bugs
- **No-Go**: Critical bugs or performance issues

---

## 7. Success Metrics

| Metric | Target |
|--------|--------|
| Time to first node | < 3 seconds |
| Node creation latency | < 100ms |
| Canvas FPS with 500 nodes | 60 fps |
| Keyboard-only workflow | 100% of operations |
| Export formats supported | 3+ (JSON, Markdown, PNG) |
| App bundle size | < 50 MB |

---

## 8. Future Scope (Post-MVP)

The following features are explicitly out of scope for MVP and should be prioritized after initial release:
- Cloud sync (iCloud integration)
- Collaborative editing
- Rich media in nodes (images, links)
- Templates and presets
- Import from other mind map formats
- Mobile companion app

---

## 9. Communication Plan

| Cadence | Format | Participants |
|---------|--------|--------------|
| Daily | Standup (5 min) | Dev team |
| Weekly | Sprint review | Stakeholders |
| Bi-weekly | Milestone checkpoint | Project team |

---

*This project plan assumes a single-developer team. Adjust timeline and resources accordingly for larger teams.*
