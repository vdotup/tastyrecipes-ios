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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var searchQuery = ""
    @Published var sortAscending = true
    
    private let api: RecipeAPIProtocol
    private var skip = 0
    private let limit = 2
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
            self.recipes = response.recipes
            skip += limit
            canLoadMore = (response.recipes.count == limit)
            sortIfNeeded()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func loadMoreRecipesIfNeeded(currentRecipe: Recipe) async {
        guard canLoadMore,
              let index = recipes.firstIndex(where: { $0.id == currentRecipe.id }),
              index > recipes.count - 5,
              !isLoading else {
            return
        }
        
        isLoading = true
        
        do {
            let response = try await api.fetchRecipes(skip: skip, limit: limit)
            self.recipes.append(contentsOf: response.recipes)
            skip += limit
            canLoadMore = (response.recipes.count == limit)
            sortIfNeeded()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func refresh() async {
        await loadInitialRecipes()
    }
    
    func search() async {
        guard !searchQuery.isEmpty else {
            await loadInitialRecipes()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let results = try await api.searchRecipes(query: searchQuery)
            self.recipes = results
            sortIfNeeded()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func toggleSort() {
        sortAscending.toggle()
        sortIfNeeded()
    }
    
    private func sortIfNeeded() {
        recipes.sort { sortAscending ? $0.name < $1.name : $0.name > $1.name }
    }
}
