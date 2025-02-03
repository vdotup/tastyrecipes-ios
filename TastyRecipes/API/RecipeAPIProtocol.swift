//
//  RecipeAPIProtocol.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import Foundation

protocol RecipeAPIProtocol {
    func fetchRecipes(skip: Int, limit: Int) async throws -> RecipeResponse
    func searchRecipes(query: String) async throws -> [Recipe]
}
