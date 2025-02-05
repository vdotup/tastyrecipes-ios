//
//  RecipeSearchView.swift
//  TastyRecipes
//
//  Created by vdotup on 04/02/2025.
//

import SwiftUI

struct RecipeSearchView: View {
    @State private var results: [Recipe] = []
    @State private var query = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isAscending: Bool
    @State private var selectedSort: String
    let api: RecipeAPIProtocol

    init(api: RecipeAPIProtocol = RecipeAPI(), defaultSort: String, defaultAsc: Bool) {
        self.api = api
        _selectedSort = State(initialValue: defaultSort)
        _isAscending = State(initialValue: defaultAsc)
    }

    var body: some View {
        List(results, id: \.id) { recipe in
            NavigationLink(destination: RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))) {
                Text(recipe.name)
            }
        }
        .navigationTitle("Search")
        .searchable(text: $query)
        .onSubmit(of: .search) {
            Task { await performSearch() }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Section("Sort By") {
                        buttonSort("name")
                        buttonSort("difficulty")
                        buttonSort("rating")
                        buttonSort("reviewCount")
                        buttonSort("caloriesPerServing")
                        buttonSort("cookTimeMinutes")
                    }
                    Divider()
                    Section("Order") {
                        Button(isAscending ? "Ascending ✓" : "Ascending") {
                            isAscending = true
                            Task { await performSearch() }
                        }
                        Button(isAscending ? "Descending" : "Descending ✓") {
                            isAscending = false
                            Task { await performSearch() }
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
        }
        .overlay {
            if isLoading {
                ProgressView("Searching...")
            } else if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if results.isEmpty && !query.isEmpty && !isLoading {
                Text("No results for '\(query)'")
                    .foregroundColor(.secondary)
            }
        }
    }

    func buttonSort(_ field: String) -> some View {
        Button(selectedSort == field ? "\(field.capitalized) ✓" : field.capitalized) {
            selectedSort = field
            Task { await performSearch() }
        }
    }

    func performSearch() async {
        guard !query.isEmpty else {
            results = []
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let order = isAscending ? "asc" : "desc"
            let response = try await api.searchRecipes(
                query: query,
                skip: 0,
                limit: 20,
                sortBy: selectedSort,
                order: order
            )
            results = response.recipes
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    RecipeSearchView(api: RecipeAPI(), defaultSort: "asc", defaultAsc: true)
}
