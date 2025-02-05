//
//  SplashView.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 04/02/2025.
//

import SwiftUI

struct SplashView: View {
    
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) {
                        scale = 1.2
                    }
                    
                }
        }
    }
}

#Preview {
    SplashView()
}
