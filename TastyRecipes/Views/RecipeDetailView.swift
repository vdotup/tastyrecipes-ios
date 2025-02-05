//
//  RecipeDetailView.swift
//  TastyRecipes
//
//  Created by vdotup on 04/02/2025.
//

import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeDetailViewModel
    @State private var fadeIn = false
    @State private var selectedTag: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: viewModel.recipe.image)) { phase in
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
                            .onAppear { fadeIn = true }
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
                Text(viewModel.recipe.name)
                    .font(.title)
                    .bold()
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: starImageName(Double(index)))
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
                }
                Text("Tags")
                    .font(.headline)
                FlowLayout(viewModel.recipe.tags, id: \.self) { tag in
                    Button {
                        selectedTag = tag
                    } label: {
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                Text("Ingredients")
                    .font(.headline)
                Text(viewModel.recipe.ingredients.joined(separator: ", "))
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
        .sheet(item: $selectedTag) { tag in
            TagResultsView(api: RecipeAPI(), tag: tag)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                fadeIn = true
            }
        }
    }

    func starImageName(_ index: Double) -> String {
        let r = viewModel.recipe.rating
        if r >= index { return "star.fill" }
        else if r + 0.5 >= index { return "star.leadinghalf.filled" }
        else { return "star" }
    }
}

#Preview {
    RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: .sample))
}
