//
//  RecipeListViewModel.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var highestRated: [Recipe] = []
    @Published var mostPopular: [Recipe] = []
    @Published var lowCalories: [Recipe] = []
    @Published var quickMeals: [Recipe] = []
    @Published var mealTypes: [String] = []
    @Published var selectedMealType: String?
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAscending = true
    @Published var sortBy = "name"

    private let api: RecipeAPIProtocol
    private var skip = 0
    private let limit = 20
    private var canLoadMore = true

    init(api: RecipeAPIProtocol = RecipeAPI()) {
        self.api = api
    }

    func loadHomeData() async {
        isLoading = true
        errorMessage = nil
        skip = 0
        canLoadMore = true
        do {
            let ratingDesc = try await api.fetchRecipes(skip: 0, limit: 10, sortBy: "rating", order: "desc")
            highestRated = ratingDesc.recipes
            let reviewDesc = try await api.fetchRecipes(skip: 0, limit: 10, sortBy: "reviewCount", order: "desc")
            mostPopular = reviewDesc.recipes
            let calAsc = try await api.fetchRecipes(skip: 0, limit: 10, sortBy: "caloriesPerServing", order: "asc")
            lowCalories = calAsc.recipes
            let cookAsc = try await api.fetchRecipes(skip: 0, limit: 10, sortBy: "cookTimeMinutes", order: "asc")
            quickMeals = cookAsc.recipes
            mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack", "Brunch"]
            selectedMealType = nil
            try await loadBaseList()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loadBaseList() async {
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
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loadMoreRecipesIfNeeded(current: Recipe) async {
        guard canLoadMore, !isLoading else { return }
        guard let index = recipes.firstIndex(where: { $0.id == current.id }) else { return }
        if index > recipes.count - 5 {
            isLoading = true
            let order = isAscending ? "asc" : "desc"
            do {
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

    func setAscending(_ value: Bool) {
        isAscending = value
        Task {
            await reloadByMealTypeIfNeeded()
        }
    }

    func setSortBy(_ newSort: String) {
        sortBy = newSort
        Task {
            await reloadByMealTypeIfNeeded()
        }
    }

    func selectMealType(_ meal: String) {
        selectedMealType = meal
        Task {
            await loadMealType()
        }
    }

    func loadMealType() async {
        guard let meal = selectedMealType else { return }
        isLoading = true
        skip = 0
        canLoadMore = false
        let order = isAscending ? "asc" : "desc"
        do {
            let response = try await api.fetchRecipesByMeal(meal, skip: 0, limit: limit, sortBy: sortBy, order: order)
            recipes = response.recipes
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func reloadByMealTypeIfNeeded() async {
        if let _ = selectedMealType {
            await loadMealType()
        } else {
            await loadBaseList()
        }
    }

    func refresh() async {
        if let _ = selectedMealType {
            await loadMealType()
        } else {
            await loadBaseList()
        }
    }
}
