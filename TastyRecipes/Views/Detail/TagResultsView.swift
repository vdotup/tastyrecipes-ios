//
//  TagResultsView.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import SwiftUI

struct TagResultsView: View, Identifiable {
    let id = UUID()
    let api: RecipeAPIProtocol
    let tag: String
    @State private var recipes: [Recipe] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(recipes, id: \.id) { recipe in
                        NavigationLink(destination: RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))) {
                            Text(recipe.name)
                        }
                    }
                }
            }
            .navigationTitle("Tag: \(tag)")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                await loadRecipesForTag()
            }
        }
    }

    func loadRecipesForTag() async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await api.fetchRecipesByTag(tag, skip: 0, limit: 30, sortBy: nil, order: nil)
            recipes = response.recipes
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
