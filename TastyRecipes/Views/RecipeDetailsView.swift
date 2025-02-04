//
//  RecipeDetailsView.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeDetailViewModel
    @State private var fadeIn: Bool = false
    
    // We assume we might have a state or property in the view model telling us if the data is loaded.
    // For demonstration, let's say we use the same 'fadeIn' or we might pass `viewModel.isLoading`.
    var isDataLoading: Bool {
        // If you have an 'isLoading' in the detail VM, use that:
        // return viewModel.isLoading
        // For this demonstration, we'll just use !fadeIn as a proxy
        return !fadeIn
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = URL(string: viewModel.recipe.image) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .transition(.opacity)
                                .onAppear {
                                    fadeIn = true
                                }
                        case .failure(_):
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(height: 200)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                Text(viewModel.recipe.name)
                    .font(.title)
                    .bold()
                
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: starImageName(for: Double(index)))
                            .foregroundColor(.yellow)
                    }
                    Text("(\(String(format: "%.1f", viewModel.recipe.rating)))")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(viewModel.recipe.reviewCount) reviews")
                        .font(.subheadline)
                }
                .font(.subheadline)
                
                HStack {
                    Text("Difficulty: \(viewModel.recipe.difficulty)")
                    Spacer()
                    Text("Cuisine: \(viewModel.recipe.cuisine)")
                }
                
                Group {
                    Text("Servings: \(viewModel.recipe.servings)")
                    Text("Prep Time: \(viewModel.recipe.prepTimeMinutes) minutes")
                    Text("Cook Time: \(viewModel.recipe.cookTimeMinutes) minutes")
                    Text("Calories/Serving: \(viewModel.recipe.caloriesPerServing)")
                    Text("Meal Types: \(viewModel.recipe.mealType.joined(separator: ", "))")
                    Text("Tags: \(viewModel.recipe.tags.joined(separator: ", "))")
                }
                
                Divider()
                
                Text("Ingredients")
                    .font(.headline)
                Text(viewModel.recipe.ingredients.joined(separator: ", "))
                
                Divider()
                
                Text("Instructions")
                    .font(.headline)
                ForEach(viewModel.recipe.instructions, id: \.self) { step in
                    Text("• \(step)")
                }
            }
            .padding()
            // If data is loading, apply placeholder redaction
            .redacted(reason: isDataLoading ? .placeholder : [])
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // mimic load done
                fadeIn = true
            }
        }
    }
    
    private func starImageName(for starIndex: Double) -> String {
        let rating = viewModel.recipe.rating
        if rating >= starIndex {
            return "star.fill"
        } else if rating + 0.5 >= starIndex {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
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
