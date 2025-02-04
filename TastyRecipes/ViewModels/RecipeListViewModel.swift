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
    @Published var filteredRecipes: [Recipe] = []
    @Published var searchQuery = ""
    @Published var sortAscending = true
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let api: RecipeAPIProtocol
    private var skip = 0
    private let limit = 20
    private var canLoadMore = true

    init(api: RecipeAPIProtocol = RecipeAPI()) {
        self.api = api
    }

    func loadInitialRecipes() async {
        isLoading = true
        errorMessage = nil
        skip = 0
        canLoadMore = true
        do {
            let response = try await api.fetchRecipes(skip: skip, limit: limit)
            recipes = response.recipes
            filteredRecipes = response.recipes
            skip += limit
            canLoadMore = response.recipes.count == limit
            sortIfNeeded()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loadMoreRecipesIfNeeded(currentRecipe: Recipe) async {
        guard canLoadMore else { return }
        guard let index = filteredRecipes.firstIndex(where: { $0.id == currentRecipe.id }) else { return }
        if index > filteredRecipes.count - 5 && !isLoading {
            isLoading = true
            do {
                let response = try await api.fetchRecipes(skip: skip, limit: limit)
                recipes.append(contentsOf: response.recipes)
                skip += limit
                canLoadMore = response.recipes.count == limit
                filterAndSortRecipes()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func refresh() async {
        await loadInitialRecipes()
    }

    func search() async {
        filterAndSortRecipes()
    }

    func toggleSort() {
        sortAscending.toggle()
        filterAndSortRecipes()
    }

    private func filterAndSortRecipes() {
        if searchQuery.isEmpty {
            filteredRecipes = recipes
        } else {
            filteredRecipes = recipes.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
        sortIfNeeded()
    }

    func sortIfNeeded() {
        if sortAscending {
            filteredRecipes.sort { $0.name < $1.name }
        } else {
            filteredRecipes.sort { $0.name > $1.name }
        }
    }
}

