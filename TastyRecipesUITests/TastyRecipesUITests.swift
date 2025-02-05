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
        // Wait for list to load
        let list = app.collectionViews["RecipeList"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        // Tap first recipe
        let firstRecipe = list.cells.element(boundBy: 0)
        firstRecipe.tap()
        
        // Verify detail screen elements
        XCTAssertTrue(app.images["RecipeHeaderImage"].exists)
        XCTAssertTrue(app.staticTexts["Ingredients"].exists)
        XCTAssertTrue(app.staticTexts["Instructions"].exists)
        
        // Go back
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testSearchFunctionality() {
        app.navigationBars["Recipes"].searchFields.element.tap()
        app.typeText("Chicken")
        app.keyboards.buttons["Search"].tap()
        
        let results = app.collectionViews["SearchResults"]
        XCTAssertTrue(results.waitForExistence(timeout: 5))
    }
}
