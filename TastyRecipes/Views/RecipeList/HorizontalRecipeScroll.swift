//
//  HorizontalRecipeScroll.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import SwiftUI

struct HorizontalRecipeScroll: View {
    let recipes: [Recipe]
    let subtitleKey: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(recipes, id: \.id) { recipe in
                    NavigationLink {
                        RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            AsyncImage(url: URL(string: recipe.image)) { phase in
                                switch phase {
                                case .empty:
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 110, height: 80)
                                        .cornerRadius(8)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 80)
                                        .clipped()
                                        .cornerRadius(8)
                                case .failure(_):
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 110, height: 80)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            Text(recipe.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            Text(subtitleText(recipe))
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 110)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    func subtitleText(_ recipe: Recipe) -> String {
        switch subtitleKey {
        case "rating":
            return String(format: "Rating %.1f", recipe.rating)
        case "reviewCount":
            return "\(recipe.reviewCount) reviews"
        case "caloriesPerServing":
            return "\(recipe.caloriesPerServing) cal"
        case "cookTimeMinutes":
            return "\(recipe.cookTimeMinutes) min"
        default:
            return ""
        }
    }
}

#Preview {
    HorizontalRecipeScroll(recipes: [], subtitleKey: "Subtitle")
}
