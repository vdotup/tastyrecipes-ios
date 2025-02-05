//
//  TastyRecipesUITestsLaunchTests.swift
//  TastyRecipesUITests
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import XCTest
@testable import TastyRecipes

class RecipeListViewModelTests: XCTestCase {
    var vm: RecipeListViewModel!
    var mockAPI: MockRecipeAPI!
    
    override func setUp() {
        mockAPI = MockRecipeAPI()
        vm = RecipeListViewModel(api: mockAPI)
    }

    func testLoadHomeData() async {
        await vm.loadHomeData()
        XCTAssertFalse(vm.highestRated.isEmpty)
        XCTAssertFalse(vm.mostPopular.isEmpty)
        XCTAssertEqual(vm.mealTypes.count, 6)
    }
    
    func testSortingChange() async {
        vm.sortBy = "rating"
        await vm.reloadByMealTypeIfNeeded()
        XCTAssertEqual(vm.sortBy, "rating")
    }
}
