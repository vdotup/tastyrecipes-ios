//
//  RecipeDetailViewModel.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

@MainActor
class RecipeDetailViewModel: ObservableObject {
    @Published var recipe: Recipe
    @Published var isLoading = false

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    func loadRecipeDetails() async {
        isLoading = false
    }
}
