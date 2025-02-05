//
//  RecipeListViewModelTests.swift
//  TastyRecipesUITests
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import XCTest
@testable import TastyRecipes

@MainActor
final class RecipeListViewModelTests: XCTestCase {
    
    var vm: RecipeListViewModel!
    var mockAPI: MockRecipeAPI!

    override func setUpWithError() throws {
        mockAPI = MockRecipeAPI()
    }

    func testLoadHomeData() async throws {
        vm = RecipeListViewModel(api: mockAPI)
        await vm.loadHomeData()
        XCTAssertFalse(vm.highestRated.isEmpty)
        XCTAssertFalse(vm.mostPopular.isEmpty)
        XCTAssertEqual(vm.mealTypes.count, 6)
    }
    
    func testSortingChange() async throws {
        vm = RecipeListViewModel(api: mockAPI)
        vm.sortBy = "rating"
        await vm.reloadByMealTypeIfNeeded()
        XCTAssertEqual(vm.sortBy, "rating")
    }
}
