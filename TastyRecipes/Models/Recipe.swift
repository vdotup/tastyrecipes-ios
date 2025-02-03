//
//  Recipe.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import Foundation

struct Recipe: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let description: String
    let thumbnail: String?
    let instructions: String?
    let ingredients: [String]?
}
