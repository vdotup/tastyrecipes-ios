//
//  Recipe.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import Foundation

struct Recipe: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let prepTimeMinutes: Int
    let cookTimeMinutes: Int
    let servings: Int
    let difficulty: String
    let cuisine: String
    let caloriesPerServing: Int
    let tags: [String]
    let userId: Int
    let image: String
    let rating: Double
    let reviewCount: Int
    let mealType: [String]
}
