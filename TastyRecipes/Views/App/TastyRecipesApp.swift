//
//  TastyRecipesApp.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

@main
struct TastyRecipesApp: App {
    
    @AppStorage("first_launch") var firstLaunch = true
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
                if firstLaunch {
                    OnboardingView(firstLaunch: $firstLaunch)
                } else {
                    ContentView()
                }
            }
        }
    }
}
