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
                                ProgressView()
                                    .frame(width: 80, height: 80)
                             ))
                .frame(width: 80, height: 80)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.name)
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    DifficultyBadge(difficulty: recipe.difficulty)
                    Text("·")
                    HStack(spacing: 2) {
                        Image(systemName: "clock")
                        Text("\(recipe.cookTimeMinutes) min")
                    }
                    .foregroundColor(.secondary)
                }
                .font(.caption)
                
                RatingView(rating: recipe.rating, reviewCount: recipe.reviewCount)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}

struct DifficultyBadge: View {
    let difficulty: String
    var color: Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "medium": return .orange
        case "hard": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        Text(difficulty)
            .font(.caption2)
            .bold()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(4)
    }
}

struct RatingView: View {
    let rating: Double
    let reviewCount: Int
    
    var body: some View {
        HStack(spacing: 4) {
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { i in
                    Image(systemName: StarIconHelper.starIcon(rating, index: Double(i)))
                        .imageScale(.small)
                }
            }
            .foregroundColor(.yellow)
            
            Text("(\(reviewCount))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    RecipeListItemView(recipe: .sample1)
}
