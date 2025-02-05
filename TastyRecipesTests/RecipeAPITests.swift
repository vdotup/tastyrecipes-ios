//
//  TastyRecipesTests.swift
//  TastyRecipesTests
//
//  Created by vdotup on 05/02/2025.
//

import XCTest
@testable import TastyRecipes

final class RecipeAPITests: XCTestCase {
    var api: RecipeAPIProtocol!
    
    override func setUpWithError() throws {
        api = RecipeAPI()
    }
    
    override func tearDownWithError() throws {
        api = nil
    }
    
    func testFetchRecipes() async throws {
        do {
            let response = try await api.fetchRecipes(skip: 0, limit: 5, sortBy: "rating", order: "desc")
            XCTAssertFalse(response.recipes.isEmpty)
            XCTAssertTrue(response.recipes.count <= 5)
        } catch {
            XCTFail("Error: \(error)")
        }
    }
    
    func testSearchRecipes() async throws {
        do {
            let query = "Sample"
            let response = try await api.searchRecipes(query: query, skip: 0, limit: 20, sortBy: nil, order: nil)
            XCTAssertFalse(response.recipes.isEmpty)
            for recipe in response.recipes {
                XCTAssertTrue(recipe.name.lowercased().contains(query.lowercased()))
            }
        } catch {
            XCTFail("Error: \(error)")
        }
    }
    
    func testFetchRecipesByMeal() async throws {
        do {
            let meal = "Lunch"
            let response = try await api.fetchRecipesByMeal(meal, skip: 0, limit: 10, sortBy: nil, order: nil)
            for recipe in response.recipes {
                XCTAssertTrue(recipe.mealType.contains(meal))
            }
        } catch {
            XCTFail("Error: \(error)")
        }
    }
}
