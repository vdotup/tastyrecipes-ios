//
//  TastyRecipesUITests.swift
//  TastyRecipesUITests
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import XCTest

final class TastyRecipesUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testRecipeNavigationFlow() {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5), "Recipe scroll view did not appear in time.")
        
        let firstRecipe = scrollView.buttons["RecipeRow_1"]
        XCTAssertTrue(firstRecipe.waitForExistence(timeout: 5), "First recipe did not appear in time.")
        
        firstRecipe.tap()
        
        XCTAssertTrue(app.images["RecipeHeaderImage"].waitForExistence(timeout: 5), "Recipe header image did not appear.")
        XCTAssertTrue(app.staticTexts["Ingredients"].waitForExistence(timeout: 5), "Ingredients section did not appear.")
        XCTAssertTrue(app.staticTexts["Instructions"].waitForExistence(timeout: 5), "Instructions section did not appear.")
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    
    func testSearchFunctionality() {
        let searchField = app.searchFields["RecipeSearchBar"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search bar did not appear.")
        
        searchField.tap()
        searchField.typeText("Chicken")
        app.keyboards.buttons["Search"].tap()
        
        let resultsList = app.tables.firstMatch
        XCTAssertTrue(resultsList.waitForExistence(timeout: 5), "Search results did not appear.")
        
        let firstResult = resultsList.cells.element(boundBy: 0)
        XCTAssertTrue(firstResult.waitForExistence(timeout: 5), "First search result did not appear.")
        
        firstResult.tap()
        XCTAssertTrue(app.images["RecipeHeaderImage"].waitForExistence(timeout: 5), "Recipe header image did not appear after search.")
    }
}
