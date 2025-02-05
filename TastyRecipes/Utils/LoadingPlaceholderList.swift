//
//  LoadingPlaceholderList.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import SwiftUI

struct LoadingPlaceholderList: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<4) { _ in
                HStack(spacing: 12) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                    VStack(alignment: .leading, spacing: 4) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 12)
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 12)
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 12)
                    }
                }
                .redacted(reason: .placeholder)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    LoadingPlaceholderList()
}
