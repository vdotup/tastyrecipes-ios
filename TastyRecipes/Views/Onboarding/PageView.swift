//
//  PageView.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 04/02/2025.
//

import SwiftUI

struct PageView: View {
    
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text(title)
                .font(.largeTitle)
                .bold()
            
            Text(description)
                .font(.body)
            
            Spacer()
        }
        .padding()
    }
}


#Preview {
    PageView(imageName: "star", title: "Star", description: "Stars are bright.")
}
