//
//  RecipeListItemView.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import SwiftUI

struct RecipeListItemView: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CachedAsyncImage(url: URL(string: recipe.image),
                             placeholder: AnyView(
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                             ))
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.red)
                    Text(recipe.difficulty)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { i in
                        Image(systemName: StarIconHelper.starIcon(recipe.rating, index: Double(i)))
                            .foregroundColor(.yellow)
                    }
                    Text("(\(String(format: "%.1f", recipe.rating)))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    RecipeListItemView(recipe: .sample)
}
