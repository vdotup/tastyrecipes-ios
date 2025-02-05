//
//  MockRecipeAPI.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import Foundation

struct MockRecipeAPI: RecipeAPIProtocol {
    func fetchRecipes(skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        let sampleRecipes: [Recipe] = [.sample1, .sample2, .sample3, .sample4]
        return RecipeResponse(recipes: sampleRecipes, total: sampleRecipes.count, skip: skip, limit: limit)
    }

    func searchRecipes(query: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        let results = [Recipe.sample1, Recipe.sample2].filter { $0.name.lowercased().contains(query.lowercased()) }
        return RecipeResponse(recipes: results, total: results.count, skip: 0, limit: limit)
    }

    func fetchTags() async throws -> [String] {
        return ["Vegan", "Quick", "Italian"]
    }

    func fetchRecipesByTag(_ tag: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        // Return random sample or empty
        let filtered = [Recipe.sample1, Recipe.sample2, Recipe.sample3, Recipe.sample4].filter { $0.tags.contains(tag) }
        return RecipeResponse(recipes: filtered, total: filtered.count, skip: skip, limit: limit)
    }

    func fetchRecipesByMeal(_ meal: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        // Return random sample or empty
        let filtered = [Recipe.sample1, Recipe.sample2, Recipe.sample3, Recipe.sample4].filter { $0.mealType.contains(meal) }
        return RecipeResponse(recipes: filtered, total: filtered.count, skip: skip, limit: limit)
    }
}
