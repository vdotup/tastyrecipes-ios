//
//  RecipeListView.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.recipes.isEmpty {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                } else {
                    List(viewModel.recipes, id: \.id) { recipe in
                        NavigationLink {
                            RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))
                        } label: {
                            Text(recipe.name)
                                .onAppear {
                                    Task {
                                        await viewModel.loadMoreRecipesIfNeeded(currentRecipe: recipe)
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
        }
        .task {
            await viewModel.loadInitialRecipes()
        }
    }
}

#Preview {
    RecipeListView()
}
