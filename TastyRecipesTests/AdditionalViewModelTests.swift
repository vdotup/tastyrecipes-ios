//
//  AdditionalViewModelTests.swift
//  TastyRecipes
//
//  Created by vdotup on 05/02/2025.
//

import XCTest
@testable import TastyRecipes

@MainActor
final class AdditionalViewModelTests: XCTestCase {
    
    var vm: RecipeListViewModel!
    var mockAPI: MockRecipeAPI!
    
    override func setUpWithError() throws {
        mockAPI = MockRecipeAPI()
        vm = RecipeListViewModel(api: mockAPI)
    }
    
    override func tearDownWithError() throws {
        vm = nil
        mockAPI = nil
    }
    
    func testSelectMealType() async {
        vm.selectMealType("Breakfast")
        await vm.loadMealType()
        let selected = vm.selectedMealType
        XCTAssertEqual(selected, "Breakfast")
    }
    
    func testReloadByMealTypeIfNeeded() async {
        vm.selectedMealType = "All"
        await vm.reloadByMealTypeIfNeeded()
        let currentRecipes = vm.recipes
        XCTAssertFalse(currentRecipes.isEmpty)
    }
}
