//
//  DessertListViewModel.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 5/25/24.
//

import Foundation

class DessertListViewModel: ObservableObject {
    
    @Published var meals = [Meal]()
    @Published var selectedMeal: Meal?
    private let dessertCategory = "dessert"
    
    func fetchDesserts(completion: @escaping () -> () ) {
        
        print("fetching desserts")
        
        MealServices.shared.fetchMeals(for: dessertCategory) { result in
            switch result {
            case .failure(let error):
                print("Error fetching meals. Error: \(error)")
            case .success(let response):
                self.meals = response.meals.sorted { $0.name.lowercased() < $1.name.lowercased() }
                completion()
                
                
            }
        }
    }
}
