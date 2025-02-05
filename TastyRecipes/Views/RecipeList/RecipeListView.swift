//
//  RecipeListView.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel: RecipeListViewModel

    init(api: RecipeAPIProtocol = RecipeAPI()) {
        _viewModel = StateObject(wrappedValue: RecipeListViewModel(api: api))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if !viewModel.highestRated.isEmpty {
                        SectionHeader(title: "Highest Rated")
                        HorizontalRecipeScroll(recipes: viewModel.highestRated, subtitleKey: "rating")
                    }
                    if !viewModel.mostPopular.isEmpty {
                        SectionHeader(title: "Most Popular")
                        HorizontalRecipeScroll(recipes: viewModel.mostPopular, subtitleKey: "reviewCount")
                    }
                    if !viewModel.lowCalories.isEmpty {
                        SectionHeader(title: "Low Calories")
                        HorizontalRecipeScroll(recipes: viewModel.lowCalories, subtitleKey: "caloriesPerServing")
                    }
                    if !viewModel.quickMeals.isEmpty {
                        SectionHeader(title: "Quick Meals")
                        HorizontalRecipeScroll(recipes: viewModel.quickMeals, subtitleKey: "cookTimeMinutes")
                    }
                    HStack {
                        Menu(viewModel.selectedMealType ?? "All Meals") {
                            Button("All Meals") {
                                viewModel.selectedMealType = nil
                                Task {
                                    await viewModel.loadBaseList()
                                }
                            }
                            ForEach(viewModel.mealTypes, id: \.self) { meal in
                                Button(meal) {
                                    viewModel.selectMealType(meal)
                                }
                            }
                        }
                        Spacer()
                        Button {
                            viewModel.setAscending(!viewModel.isAscending)
                        } label: {
                            Image(systemName: viewModel.isAscending ? "arrow.down" : "arrow.up")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    if viewModel.isLoading && viewModel.recipes.isEmpty {
                        LoadingPlaceholderList()
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.recipes, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))) {
                                    RecipeListItemView(recipe: recipe)
                                        .onAppear {
                                            Task {
                                                await viewModel.loadMoreRecipesIfNeeded(current: recipe)
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        RecipeSearchView(
                            defaultSort: viewModel.sortBy,
                            defaultAsc: viewModel.isAscending
                        )
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .task {
                await viewModel.loadHomeData()
            }
        }
    }
}

#Preview {
    RecipeListView(api: MockRecipeAPI())
}


struct MockRecipeAPI: RecipeAPIProtocol {
    func fetchRecipes(skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        let sampleRecipes = [
            Recipe(
                id: 1,
                name: "Mock1",
                ingredients: [],
                instructions: [],
                prepTimeMinutes: 0,
                cookTimeMinutes: 0,
                servings: 0,
                difficulty: "Easy",
                cuisine: "MockCuisine",
                caloriesPerServing: 0,
                tags: [],
                userId: 0,
                image: "",
                rating: 4.0,
                reviewCount: 10,
                mealType: []
            ),
            Recipe(
                id: 2,
                name: "Mock2",
                ingredients: [],
                instructions: [],
                prepTimeMinutes: 0,
                cookTimeMinutes: 0,
                servings: 0,
                difficulty: "Hard",
                cuisine: "MockCuisine",
                caloriesPerServing: 0,
                tags: [],
                userId: 0,
                image: "",
                rating: 3.5,
                reviewCount: 5,
                mealType: []
            )
        ]
        return RecipeResponse(recipes: sampleRecipes, total: 2, skip: 0, limit: 2)
    }

    func searchRecipes(query: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        return RecipeResponse(recipes: [], total: 0, skip: 0, limit: 0)
    }

    func fetchTags() async throws -> [String] {
        return ["Vegan", "Quick", "Italian"]
    }

    func fetchRecipesByTag(_ tag: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        return RecipeResponse(recipes: [], total: 0, skip: 0, limit: 0)
    }

    func fetchRecipesByMeal(_ meal: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        return RecipeResponse(recipes: [], total: 0, skip: 0, limit: 0)
    }
}
