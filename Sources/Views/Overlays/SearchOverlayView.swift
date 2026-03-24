import SwiftUI
import SwiftData

struct SearchOverlayView: View {
    let mindMap: MindMap?
    @Bindable var canvasViewModel: CanvasViewModel
    @Bindable var mindMapViewModel: MindMapViewModel

    @Environment(\.dismiss) private var dismiss
    @FocusState private var searchFieldFocused: Bool

    @State private var searchText: String = ""
    @State private var searchResults: [MindMapNode] = []
    @State private var selectedResultIndex: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Search nodes...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.title3)
                    .focused($searchFieldFocused)
                    .onSubmit {
                        selectCurrentResult()
                    }

                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        searchResults = []
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .background(.background)

            Divider()

            // Results
            if searchResults.isEmpty && !searchText.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("No results found")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if searchResults.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "text.magnifyingglass")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Type to search")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(searchResults.indices, id: \.self) { index in
                    let node = searchResults[index]
                    Button(action: {
                        selectNode(node)
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(node.title)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)

                                if !node.notes.isEmpty {
                                    Text(node.notes)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                            }

                            Spacer()

                            if node.parentId == nil {
                                Text("Root")
                                    .font(.caption)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundStyle(.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }

                            Text("Depth \(node.depth)")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 4)
                        .background(index == selectedResultIndex ? Color.blue.opacity(0.1) : Color.clear)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .onHover { hovering in
                        if hovering {
                            selectedResultIndex = index
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .frame(width: 400, height: 300)
        .onAppear {
            searchFieldFocused = true
        }
        .onChange(of: searchText) { _, newValue in
            performSearch(newValue)
        }
        .onSubmit(of: .text) {
            selectCurrentResult()
        }
    }

    private func performSearch(_ query: String) {
        guard let mindMap = mindMap, !query.isEmpty else {
            searchResults = []
            return
        }

        let lowercasedQuery = query.lowercased()
        searchResults = mindMap.nodes.filter { node in
            node.title.lowercased().contains(lowercasedQuery) ||
            node.notes.lowercased().contains(lowercasedQuery)
        }
        selectedResultIndex = 0
    }

    private func selectNode(_ node: MindMapNode) {
        canvasViewModel.selectNode(node.id)
        mindMapViewModel.selectNode(node.id)
        dismiss()
    }

    private func selectCurrentResult() {
        guard !searchResults.isEmpty else { return }
        selectNode(searchResults[selectedResultIndex])
    }
}
