//
//  RecipeListView.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    init(api: RecipeAPIProtocol = RecipeAPI()) {
        _viewModel = StateObject(wrappedValue: RecipeListViewModel(api: api))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search recipes...", text: $viewModel.searchQuery)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            Task {
                                await viewModel.search()
                            }
                        }
                    
                    Button {
                        Task {
                            await viewModel.search()
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                .padding(.horizontal)
                
                Button {
                    withAnimation {
                        viewModel.toggleSort()
                    }
                } label: {
                    Text(viewModel.sortAscending ? "Sort Desc" : "Sort Asc")
                }
                .padding(.bottom, 4)
                
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
                .refreshable {
                    await viewModel.refresh()
                }
                .listStyle(.plain)
                .animation(.default, value: viewModel.recipes)
            }
            .navigationTitle("Recipes")
        }
        .task {
            await viewModel.loadInitialRecipes()
        }
    }
}

#Preview {
    RecipeListView(api: MockRecipeAPI())
}

struct MockRecipeAPI: RecipeAPIProtocol {
    func fetchRecipes(skip: Int, limit: Int) async throws -> RecipeResponse {
        let sampleRecipes = [
            Recipe(
                id: 1, name: "Mock1", ingredients: [], instructions: [], prepTimeMinutes: 0,
                cookTimeMinutes: 0, servings: 0, difficulty: "", cuisine: "", caloriesPerServing: 0,
                tags: [], userId: 0, image: "", rating: 0, reviewCount: 0, mealType: []
            ),
            Recipe(
                id: 2, name: "Mock2", ingredients: [], instructions: [], prepTimeMinutes: 0,
                cookTimeMinutes: 0, servings: 0, difficulty: "", cuisine: "", caloriesPerServing: 0,
                tags: [], userId: 0, image: "", rating: 0, reviewCount: 0, mealType: []
            )
        ]
        return RecipeResponse(recipes: sampleRecipes, total: 2, skip: 0, limit: 2)
    }
    
    func searchRecipes(query: String) async throws -> [Recipe] {
        return []
    }
}
