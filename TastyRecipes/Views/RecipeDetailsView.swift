//
//  RecipeDetailsView.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: viewModel.recipe.image)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                
                Text(viewModel.recipe.name)
                    .font(.title)
                    .padding(.bottom, 4)
                
                HStack {
                    Text("Difficulty: \(viewModel.recipe.difficulty)")
                    Spacer()
                    Text("Rating: \(String(format: "%.1f", viewModel.recipe.rating)) (\(viewModel.recipe.reviewCount) reviews)")
                }
                .font(.subheadline)
                
                Text("Cuisine: \(viewModel.recipe.cuisine)")
                    .font(.subheadline)
                
                Text("Meal Type: \(viewModel.recipe.mealType.joined(separator: ", "))")
                    .font(.subheadline)
                
                Text("Servings: \(viewModel.recipe.servings)")
                    .font(.subheadline)
                
                Text("Prep Time: \(viewModel.recipe.prepTimeMinutes) minutes")
                    .font(.subheadline)
                
                Text("Cook Time: \(viewModel.recipe.cookTimeMinutes) minutes")
                    .font(.subheadline)
                
                Text("Calories/Serving: \(viewModel.recipe.caloriesPerServing)")
                    .font(.subheadline)
                
                Text("Tags: \(viewModel.recipe.tags.joined(separator: ", "))")
                    .font(.subheadline)
                
                Text("Ingredients:")
                    .font(.headline)
                Text(viewModel.recipe.ingredients.joined(separator: ", "))
                
                Text("Instructions:")
                    .font(.headline)
                ForEach(viewModel.recipe.instructions, id: \.self) { step in
                    Text("• \(step)")
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let sampleRecipe = Recipe(
        id: 1,
        name: "Sample Dish",
        ingredients: ["Eggs", "Milk", "Flour"],
        instructions: ["Mix ingredients", "Bake for 30 minutes"],
        prepTimeMinutes: 15,
        cookTimeMinutes: 30,
        servings: 4,
        difficulty: "Easy",
        cuisine: "International",
        caloriesPerServing: 200,
        tags: ["Breakfast", "Baked"],
        userId: 1,
        image: "https://dummyjson.com/image/i/products/1/thumbnail.jpg",
        rating: 4.5,
        reviewCount: 10,
        mealType: ["Breakfast", "Snack"]
    )
    RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: sampleRecipe))
}
