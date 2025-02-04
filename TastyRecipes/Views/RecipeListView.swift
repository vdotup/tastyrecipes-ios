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
            ZStack {
                if viewModel.isLoading && viewModel.filteredRecipes.isEmpty {
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
                    List(viewModel.filteredRecipes, id: \.id) { recipe in
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
                        }
                    }
                    .listStyle(PlainListStyle())
                    .searchable(text: $viewModel.searchQuery)
                    .onSubmit(of: .search) {
                        Task {
                            await viewModel.search()
                        }
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            viewModel.toggleSort()
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
            .task {
                await viewModel.loadInitialRecipes()
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
