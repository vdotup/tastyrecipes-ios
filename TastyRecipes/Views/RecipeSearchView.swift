//
//  RecipeSearchView.swift
//  TastyRecipes
//
//  Created by vdotup on 04/02/2025.
//

import SwiftUI

struct RecipeSearchView: View {
    @State private var query = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var results: [Recipe] = []
    let api: RecipeAPIProtocol

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Search recipes", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Search") {
                    Task {
                        await performSearch()
                    }
                }
            }
            .padding()
            if isLoading {
                ProgressView("Searching...")
            } else if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                List(results, id: \.id) { recipe in
                    NavigationLink(destination: RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))) {
                        Text(recipe.name)
                    }
                }
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }

    func performSearch() async {
        guard !query.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        do {
            let response = try await api.searchRecipes(query: query, skip: 0, limit: 20, sortBy: "name", order: "asc")
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
