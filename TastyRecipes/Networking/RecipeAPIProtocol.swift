//
//  RecipeAPIProtocol.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import Foundation

protocol RecipeAPIProtocol {
    func fetchRecipes(skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse
    func searchRecipes(query: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse
    func fetchTags() async throws -> [String]
    func fetchRecipesByTag(_ tag: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse
    func fetchRecipesByMeal(_ meal: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse
}

