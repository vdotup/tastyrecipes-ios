//
//  RecipeDetailView.swift
//  TastyRecipes
//
//  Created by vdotup on 04/02/2025.
//

import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeDetailViewModel
    @State private var fadeIn: Bool = false

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
            .redacted(reason: !fadeIn ? .placeholder : [])
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                fadeIn = true
            }
        }
    }

    func starImageName(for starIndex: Double) -> String {
        let rating = viewModel.recipe.rating
        if rating >= starIndex { return "star.fill" }
        else if rating + 0.5 >= starIndex { return "star.leadinghalf.filled" }
        else { return "star" }
    }
}

#Preview {
    let sampleRecipe = Recipe(
        id: 10,
        name: "Preview Dish",
        ingredients: ["Salt", "Pepper"],
        instructions: ["Season the dish", "Serve hot"],
        prepTimeMinutes: 10,
        cookTimeMinutes: 25,
        servings: 2,
        difficulty: "Medium",
        cuisine: "Various",
        caloriesPerServing: 180,
        tags: ["Spicy"],
        userId: 1,
        image: "",
        rating: 4.5,
        reviewCount: 12,
        mealType: ["Dinner"]
    )
    RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: sampleRecipe))
}
