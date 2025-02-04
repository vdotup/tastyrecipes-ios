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
            VStack(spacing: 0) {
                if !viewModel.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.tags, id: \.self) { tag in
                                Button {
                                    viewModel.selectTag(tag)
                                } label: {
                                    Text(tag)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
                if !viewModel.meals.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.meals, id: \.self) { meal in
                                Button {
                                    Task {
                                        await viewModel.loadRecipesByMeal(meal)
                                    }
                                } label: {
                                    Text(meal)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
                if !viewModel.topRated.isEmpty {
                    Text("Highest Rated")
                        .font(.headline)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.topRated, id: \.id) { recipe in
                                NavigationLink {
                                    RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        AsyncImage(url: URL(string: recipe.image)) { phase in
                                            switch phase {
                                            case .empty:
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: 100, height: 80)
                                                    .cornerRadius(8)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 80)
                                                    .clipped()
                                                    .cornerRadius(8)
                                            case .failure(_):
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100, height: 80)
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        Text(recipe.name)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                        HStack(spacing: 2) {
                                            ForEach(1...5, id: \.self) { i in
                                                Image(systemName: starIcon(recipe.rating, i: Double(i)))
                                                    .foregroundColor(.yellow)
                                                    .font(.system(size: 10))
                                            }
                                            Text("(\(String(format: "%.1f", recipe.rating)))")
                                                .font(.system(size: 10))
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .frame(width: 100)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 8)
                }
                ZStack {
                    if viewModel.isLoading && viewModel.recipes.isEmpty {
                        VStack(spacing: 16) {
                            ForEach(0..<4) { _ in
                                HStack(spacing: 12) {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: 12)
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 100, height: 12)
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 60, height: 12)
                                    }
                                }
                                .redacted(reason: .placeholder)
                            }
                        }
                        .padding()
                    } else {
                        List(viewModel.recipes, id: \.id) { recipe in
                            NavigationLink(destination: RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))) {
                                HStack(alignment: .top, spacing: 12) {
                                    AsyncImage(url: URL(string: recipe.image)) { phase in
                                        switch phase {
                                        case .empty:
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(8)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 60, height: 60)
                                                .clipped()
                                                .cornerRadius(8)
                                        case .failure(_):
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(recipe.name)
                                            .font(.headline)
                                        HStack(spacing: 8) {
                                            Image(systemName: "flame.fill")
                                                .foregroundColor(.red)
                                            Text(recipe.difficulty)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        HStack(spacing: 4) {
                                            ForEach(1...5, id: \.self) { i in
                                                Image(systemName: starIcon(recipe.rating, i: Double(i)))
                                                    .foregroundColor(.yellow)
                                            }
                                            Text("(\(String(format: "%.1f", recipe.rating)))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .onAppear {
                                    Task {
                                        await viewModel.loadMoreRecipesIfNeeded(currentRecipe: recipe)
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            await viewModel.refresh()
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        NavigationLink {
                            RecipeSearchView(api: viewModel.api)
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        Menu {
                            Button("Sort by Name") {
                                viewModel.setSortBy("name")
                            }
                            Button("Sort by Difficulty") {
                                viewModel.setSortBy("difficulty")
                            }
                            Button("Sort by Rating") {
                                viewModel.setSortBy("rating")
                            }
                            Divider()
                            Button(viewModel.isAscending ? "Ascending ✓" : "Ascending") {
                                viewModel.setAscending(true)
                            }
                            Button(viewModel.isAscending ? "Descending" : "Descending ✓") {
                                viewModel.setAscending(false)
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }
                }
            }
            .task {
                await viewModel.loadInitialData()
            }
        }
    }

    func starIcon(_ rating: Double, i: Double) -> String {
        if rating >= i { return "star.fill" }
        else if rating + 0.5 >= i { return "star.leadinghalf.filled" }
        else { return "star" }
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
