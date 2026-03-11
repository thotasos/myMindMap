import SwiftUI
import SwiftData

struct SearchOverlayView: View {
    let mindMap: MindMap?
    @Bindable var canvasViewModel: CanvasViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var searchText: String = ""
    @State private var searchResults: [MindMapNode] = []

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
                List(searchResults, id: \.id) { node in
                    Button(action: {
                        selectNode(node)
                    }) {
                        HStack {
                            Text(node.text)
                                .foregroundStyle(.primary)

                            Spacer()

                            if node.parent == nil {
                                Text("Root")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .buttonStyle(.plain)
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
            if let first = searchResults.first {
                selectNode(first)
            }
        }
    }

    @FocusState private var searchFieldFocused: Bool

    private func performSearch(_ query: String) {
        guard let mindMap = mindMap, !query.isEmpty else {
            searchResults = []
            return
        }

        searchResults = mindMap.nodes.filter { node in
            node.text.localizedCaseInsensitiveContains(query)
        }
    }

    private func selectNode(_ node: MindMapNode) {
        canvasViewModel.selectNode(node.id)
        dismiss()
    }
}
