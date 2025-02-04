//
//  OnboardingView.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 04/02/2025.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var firstLaunch: Bool
    
    var body: some View {
        TabView {
            PageView(imageName: "fork.knife", title: "Welcome", description: "Explore delicious recipes!")
            PageView(imageName: "magnifyingglass", title: "Search", description: "Use the search to find your favorite meal!")
            PageView(imageName: "arrow.up.arrow.down", title: "Sort", description: "Sort recipes as you like!")
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .overlay(
            Button(action: {
                withAnimation {
                    firstLaunch.toggle()
                }
            }) {
                Text("Get Started")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
                .padding(),
            alignment: .bottom
        )
    }
}

#Preview {
    OnboardingView(firstLaunch: .constant(true))
}

