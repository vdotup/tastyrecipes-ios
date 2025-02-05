//
//  RecipeDetailView.swift
//  TastyRecipes
//
//  Created by vdotup on 04/02/2025.
//

import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeaderSection(recipe: viewModel.recipe)
                
                QuickInfoGrid(recipe: viewModel.recipe)
                
                TagsSection(recipe: viewModel.recipe)
                
                IngredientsSection(ingredients: viewModel.recipe.ingredients)
                
                InstructionsSection(instructions: viewModel.recipe.instructions)
            }
            .padding()
        }
        .navigationTitle(viewModel.recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HeaderSection: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: URL(string: recipe.image),
                             placeholder: AnyView(
                                ProgressView()
                                    .frame(height: 200)
                             ))
                .frame(height: 200)
                .cornerRadius(12)
                .shadow(radius: 4)
            
            HStack {
                RatingView(rating: recipe.rating, reviewCount: recipe.reviewCount)
                Spacer()
                DifficultyBadge(difficulty: recipe.difficulty)
            }
        }
    }
}

struct QuickInfoGrid: View {
    let recipe: Recipe
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            InfoCell(title: "Prep Time", value: "\(recipe.prepTimeMinutes) min")
            InfoCell(title: "Cook Time", value: "\(recipe.cookTimeMinutes) min")
            InfoCell(title: "Servings", value: "\(recipe.servings)")
            InfoCell(title: "Calories", value: "\(recipe.caloriesPerServing)")
        }
        .padding(.vertical)
    }
}

struct InfoCell: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct TagsSection: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tags")
                .font(.title3.bold())
                .padding(.top)
                .padding(.bottom, 6)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(recipe.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
            }
        }
    }
}

struct IngredientsSection: View {
    let ingredients: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ingredients")
                .font(.title3.bold())
                .padding(.top)
                .padding(.bottom, 6)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(ingredients, id: \.self) { ingredient in
                    HStack(alignment: .top) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .padding(.top, 6)
                        Text(ingredient)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct InstructionsSection: View {
    let instructions: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Instructions")
                .font(.title3.bold())
                .padding(.top)
                .padding(.bottom, 6)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Step \(index + 1)")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                        }
                        Text(instruction)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
        }
    }
}

#Preview {
    RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: .sample1))
}
