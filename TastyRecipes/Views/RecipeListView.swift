//
//  RecipeListView.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search recipes...", text: $viewModel.searchQuery)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            Task {
                                await viewModel.search()
                            }
                        }
                    
                    Button {
                        Task {
                            await viewModel.search()
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                .padding(.horizontal)
                
                Button {
                    viewModel.toggleSort()
                } label: {
                    Text(viewModel.sortAscending ? "Sort Desc" : "Sort Asc")
                }
                .padding(.bottom, 4)
                
                List(viewModel.recipes, id: \.id) { recipe in
                    NavigationLink {
                        RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))
                    } label: {
                        Text(recipe.name)
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreRecipesIfNeeded(currentRecipe: recipe)
                                }
                            }
                    }
                }
                .refreshable {
                    await viewModel.refresh()
                }
                .listStyle(.plain)
            }
            .navigationTitle("Recipes")
        }
        .task {
            await viewModel.loadInitialRecipes()
        }
    }
}

#Preview {
    RecipeListView()
}
