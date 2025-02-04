//
//  TastyRecipesApp.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

@main
struct TastyRecipesApp: App {
    
    @State private var showSplash: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplash.toggle()
                            }
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}
