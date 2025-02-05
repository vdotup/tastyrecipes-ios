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
    let api: RecipeAPIProtocol

    init(api: RecipeAPIProtocol = RecipeAPI()) {
        self.api = api
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

    func performSearch() async {
        guard !query.isEmpty else {
            results = []
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let response = try await api.searchRecipes(
                query: query,
                skip: 0,
                limit: 20,
                sortBy: nil,
                order: nil
            )
            results = response.recipes
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    RecipeSearchView(api: RecipeAPI())
}
