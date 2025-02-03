//
//  RecipeDetailViewModel.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

@MainActor
class RecipeDetailViewModel: ObservableObject {
    let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
