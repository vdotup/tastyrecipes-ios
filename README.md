# TastyRecipes

TastyRecipes is a sample SwiftUI application that demonstrates fetching, displaying, and managing recipe data. It leverages Swift Concurrency (`async/await`). The project also showcases unit testing (in `TastyRecipesTests`) and UI testing (in `TastyRecipesUITests`).

---

## Table of Contents
- [Features](#features)
- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [Testing](#testing)

---

## Features

1. **Splash & Onboarding**  
   - Displays a splash screen at launch. 
   - Simple onboarding flow via a `TabView`.
     
<img src="https://github.com/user-attachments/assets/3fc1253a-4953-419c-b3a2-eb162a66c6a8" alt="splash" width="200"/> <img src="https://github.com/user-attachments/assets/f8e2a013-17b9-49f9-9ccb-def9f6614b1f" alt="onboarding" width="200"/>



2. **Recipe Listing**  
   - Home screen with multiple horizontal sections (Highest Rated, Most Popular, etc.).  
   - Filter and sort recipes by meal type, rating, cook time, etc.

<img src="https://github.com/user-attachments/assets/cacc564b-41e7-49c9-9a60-bcd0741d1eaf" alt="list" width="200"/>



3. **Recipe Detail**  
   - Detailed view for each recipe (ingredients, instructions, quick info like prep time).  
   - Image loading and caching via a `CachedAsyncImage`.

<img src="https://github.com/user-attachments/assets/6d176368-7cbe-4a7e-b72b-8618abf82f33" alt="list" width="200"/>



4. **Search**  
   - Built-in search bar for recipes.  
   - Displays results in a list.

<img src="https://github.com/user-attachments/assets/6574d4e7-970d-4e2e-b5c6-1b59d7e3471b" alt="list" width="200"/>



5. **Tags & Meal Types**  
   - Fetch recipes by specific tags (e.g., “Vegan”, “Italian”) or meal types.

---

## Project Structure
<img width="374" alt="structure" src="https://github.com/user-attachments/assets/03cb7398-da3b-4c87-b9e4-bc2dedc16f2f" />


---

## Requirements

- **Xcode 14+**  
- **iOS 16+**  
- **Swift 5.5+**

---

## Testing

### Unit Tests

- Tests cover key view models (`RecipeListViewModel`, etc.) and API logic (`RecipeAPITests`).



### UI Tests

- Verify main user flows (navigating to details, searching, etc.).


<img width="667" alt="tests" src="https://github.com/user-attachments/assets/2086a62d-e4ce-45f3-8b5e-6bf1df78cb0c" />

---
