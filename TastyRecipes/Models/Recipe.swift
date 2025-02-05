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
    
    static let sample1 = Recipe(
        id: 1,
        name: "Sample1",
        ingredients: ["Ingredient A", "Ingredient B"],
        instructions: ["Step 1", "Step 2"],
        prepTimeMinutes: 10,
        cookTimeMinutes: 20,
        servings: 2,
        difficulty: "Easy",
        cuisine: "MockCuisine",
        caloriesPerServing: 300,
        tags: ["Vegan", "Quick"],
        userId: 0,
        image: "",
        rating: 4.0,
        reviewCount: 10,
        mealType: ["Lunch"]
    )
    
    static let sample2 = Recipe(
        id: 2,
        name: "Sample2",
        ingredients: ["Ingredient A2", "Ingredient B2"],
        instructions: ["Step 1", "Step 2"],
        prepTimeMinutes: 5,
        cookTimeMinutes: 15,
        servings: 4,
        difficulty: "Hard",
        cuisine: "Italian",
        caloriesPerServing: 400,
        tags: ["Spicy"],
        userId: 0,
        image: "",
        rating: 3.5,
        reviewCount: 5,
        mealType: ["Dinner"]
    )
    
    static let sample3 = Recipe(
        id: 3,
        name: "Sample3",
        ingredients: [],
        instructions: [],
        prepTimeMinutes: 0,
        cookTimeMinutes: 0,
        servings: 0,
        difficulty: "Hard",
        cuisine: "Italian",
        caloriesPerServing: 350,
        tags: [],
        userId: 0,
        image: "",
        rating: 3.5,
        reviewCount: 5,
        mealType: []
    )
    
    static let sample4 = Recipe(
        id: 4,
        name: "Sample4",
        ingredients: [],
        instructions: [],
        prepTimeMinutes: 0,
        cookTimeMinutes: 0,
        servings: 0,
        difficulty: "Hard",
        cuisine: "Italian",
        caloriesPerServing: 250,
        tags: [],
        userId: 0,
        image: "",
        rating: 3.5,
        reviewCount: 5,
        mealType: []
    )
    
}
