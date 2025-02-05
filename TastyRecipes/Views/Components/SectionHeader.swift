//
//  SectionHeader.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import SwiftUI

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SectionHeader(title: "Section Header")
}
