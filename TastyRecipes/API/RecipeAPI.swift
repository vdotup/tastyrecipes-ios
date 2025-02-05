//
//  RecipeAPI.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import Foundation

struct RecipeAPI: RecipeAPIProtocol {
    private let baseURL = "https://dummyjson.com"

    func fetchRecipes(skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        var components = URLComponents(string: "\(baseURL)/recipes")!
        var queryItems = [
            URLQueryItem(name: "skip", value: "\(skip)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        if let sortBy = sortBy {
            queryItems.append(URLQueryItem(name: "sortBy", value: sortBy))
        }
        if let order = order {
            queryItems.append(URLQueryItem(name: "order", value: order))
        }
        components.queryItems = queryItems
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(RecipeResponse.self, from: data)
    }

    func searchRecipes(query: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        var components = URLComponents(string: "\(baseURL)/recipes/search")!
        var queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "skip", value: "\(skip)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        if let sortBy = sortBy {
            queryItems.append(URLQueryItem(name: "sortBy", value: sortBy))
        }
        if let order = order {
            queryItems.append(URLQueryItem(name: "order", value: order))
        }
        components.queryItems = queryItems
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(RecipeResponse.self, from: data)
    }

    func fetchTags() async throws -> [String] {
        let url = URL(string: "\(baseURL)/recipes/tags")!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([String].self, from: data)
    }

    func fetchRecipesByTag(_ tag: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        var components = URLComponents(string: "\(baseURL)/recipes")!
        var queryItems = [
            URLQueryItem(name: "skip", value: "\(skip)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "tag", value: tag)
        ]
        if let sortBy = sortBy {
            queryItems.append(URLQueryItem(name: "sortBy", value: sortBy))
        }
        if let order = order {
            queryItems.append(URLQueryItem(name: "order", value: order))
        }
        components.queryItems = queryItems
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(RecipeResponse.self, from: data)
    }

    func fetchRecipesByMeal(_ meal: String, skip: Int, limit: Int, sortBy: String?, order: String?) async throws -> RecipeResponse {
        var components = URLComponents(string: "\(baseURL)/recipes")!
        var queryItems = [
            URLQueryItem(name: "skip", value: "\(skip)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "meal", value: meal)
        ]
        if let sortBy = sortBy {
            queryItems.append(URLQueryItem(name: "sortBy", value: sortBy))
        }
        if let order = order {
            queryItems.append(URLQueryItem(name: "order", value: order))
        }
        components.queryItems = queryItems
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(RecipeResponse.self, from: data)
    }
}
