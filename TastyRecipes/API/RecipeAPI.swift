//
//  RecipeAPI.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import Foundation

struct RecipeAPI: RecipeAPIProtocol {
    private let baseURL = "https://dummyjson.com"
    
    func fetchRecipes(skip: Int = 0, limit: Int = 20) async throws -> RecipeResponse {
        guard let url = URL(string: "\(baseURL)/recipes?limit=\(limit)&skip=\(skip)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(RecipeResponse.self, from: data)
    }
    
    func searchRecipes(query: String) async throws -> [Recipe] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/recipes/search?q=\(encodedQuery)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }
        
        let searchResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return searchResponse.recipes
    }
}
