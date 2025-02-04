//
//  RecipeListViewModel.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var topRated: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAscending = true
    @Published var sortBy = "name"
    @Published var tags: [String] = []
    @Published var selectedTag: String?
    @Published var meals: [String] = []
    
    let api: RecipeAPIProtocol
    
    private var skip = 0
    private let limit = 20
    private var canLoadMore = true

    init(api: RecipeAPIProtocol = RecipeAPI()) {
        self.api = api
    }

    func loadInitialData() async {
        isLoading = true
        errorMessage = nil
        skip = 0
        canLoadMore = true
        do {
            let order = isAscending ? "asc" : "desc"
            let response = try await api.fetchRecipes(skip: skip, limit: limit, sortBy: sortBy, order: order)
            recipes = response.recipes
            skip += limit
            canLoadMore = response.recipes.count == limit
            topRated = try await api.fetchRecipes(skip: 0, limit: 10, sortBy: "rating", order: "desc").recipes
            tags = try await api.fetchTags()
            meals = ["Breakfast", "Lunch", "Dinner"]
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loadMoreRecipesIfNeeded(currentRecipe: Recipe) async {
        guard canLoadMore, !isLoading else { return }
        guard let index = recipes.firstIndex(where: { $0.id == currentRecipe.id }) else { return }
        if index > recipes.count - 5 {
            isLoading = true
            do {
                let order = isAscending ? "asc" : "desc"
                let response = try await api.fetchRecipes(skip: skip, limit: limit, sortBy: sortBy, order: order)
                recipes.append(contentsOf: response.recipes)
                skip += limit
                canLoadMore = response.recipes.count == limit
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func refresh() async {
        await loadInitialData()
    }

    func setAscending(_ value: Bool) {
        isAscending = value
        Task {
            await loadInitialData()
        }
    }

    func setSortBy(_ newSort: String) {
        sortBy = newSort
        Task {
            await loadInitialData()
        }
    }

    func selectTag(_ tag: String) {
        selectedTag = tag
        Task {
            await loadRecipesByTag()
        }
    }

    func loadRecipesByTag() async {
        guard let tag = selectedTag else { return }
        isLoading = true
        errorMessage = nil
        skip = 0
        canLoadMore = false
        do {
            let order = isAscending ? "asc" : "desc"
            let response = try await api.fetchRecipesByTag(tag, skip: skip, limit: limit, sortBy: sortBy, order: order)
            recipes = response.recipes
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loadRecipesByMeal(_ meal: String) async {
        isLoading = true
        errorMessage = nil
        skip = 0
        canLoadMore = false
        do {
            let order = isAscending ? "asc" : "desc"
            let response = try await api.fetchRecipesByMeal(meal, skip: skip, limit: limit, sortBy: sortBy, order: order)
            recipes = response.recipes
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
