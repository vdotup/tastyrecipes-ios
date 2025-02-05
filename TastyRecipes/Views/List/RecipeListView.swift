//
//  RecipeListView.swift
//  TastyRecipes
//
//  Created by vdotup on 03/02/2025.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel: RecipeListViewModel
    
    private let sortOptions = ["name", "cookTimeMinutes", "rating", "reviewCount", "caloriesPerServing"]
    
    init(api: RecipeAPIProtocol = RecipeAPI()) {
        _viewModel = StateObject(wrappedValue: RecipeListViewModel(api: api))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Horizontal highlight sections
                    if !viewModel.highestRated.isEmpty {
                        HorizontalRecipeScroll(title: "Highest Rated",
                                               recipes: viewModel.highestRated,
                                               subtitleKey: "rating")
                        .animation(.easeInOut, value: viewModel.highestRated)
                    }
                    if !viewModel.mostPopular.isEmpty {
                        HorizontalRecipeScroll(title: "Most Popular",
                                               recipes: viewModel.mostPopular,
                                               subtitleKey: "reviewCount")
                        .animation(.easeInOut, value: viewModel.mostPopular)
                    }
                    if !viewModel.lowCalories.isEmpty {
                        HorizontalRecipeScroll(title: "Low Calories",
                                               recipes: viewModel.lowCalories,
                                               subtitleKey: "caloriesPerServing")
                        .animation(.easeInOut, value: viewModel.lowCalories)
                    }
                    if !viewModel.quickMeals.isEmpty {
                        HorizontalRecipeScroll(title: "Quick Meals",
                                               recipes: viewModel.quickMeals,
                                               subtitleKey: "cookTimeMinutes")
                        .animation(.easeInOut, value: viewModel.quickMeals)
                    }
                    
                    HStack {
                        Menu {
                            Button("All Meals") {
                                viewModel.selectedMealType = nil
                                Task {
                                    await viewModel.loadBaseList()
                                }
                            }
                            ForEach(viewModel.mealTypes, id: \.self) { meal in
                                Button(meal) {
                                    viewModel.selectMealType(meal)
                                }
                            }
                        } label: {
                            Label(viewModel.selectedMealType ?? "All Meals",
                                  systemImage: "fork.knife")
                            .font(.callout)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        Picker("Sort By", selection: $viewModel.sortBy) {
                            ForEach(sortOptions, id: \.self) { option in
                                Text(option.capitalized).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: viewModel.sortBy) { newValue in
                            Task {
                                viewModel.setSortBy(newValue)
                            }
                        }
                        
                        Button {
                            withAnimation {
                                viewModel.setAscending(!viewModel.isAscending)
                            }
                        } label: {
                            Image(systemName: viewModel.isAscending
                                  ? "arrow.up.arrow.down.circle"
                                  : "arrow.up.arrow.down.circle.fill")
                            .font(.title3)
                        }
                    }
                    .padding(.horizontal)
                    
                    if viewModel.isLoading && viewModel.recipes.isEmpty {
                        LoadingPlaceholderList()
                            .redacted(reason: .placeholder)
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.recipes, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailView(
                                    viewModel: RecipeDetailViewModel(recipe: recipe))
                                ) {
                                    RecipeListItemView(recipe: recipe)
                                        .onAppear {
                                            Task {
                                                await viewModel.loadMoreRecipesIfNeeded(current: recipe)
                                            }
                                        }
                                }
                                Divider()
                            }
                        }
                        .animation(.easeInOut, value: viewModel.recipes)
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                    }
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("Icon")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        RecipeSearchView(api: viewModelIsUsingMock ? MockRecipeAPI() : RecipeAPI())
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .task {
                await viewModel.loadHomeData()
            }
        }
    }
    
    var viewModelIsUsingMock: Bool {
        return (viewModel as Any) is RecipeListViewModel &&
        type(of: viewModel.api) == MockRecipeAPI.self
    }
}

#Preview {
    RecipeListView(api: MockRecipeAPI())
}
