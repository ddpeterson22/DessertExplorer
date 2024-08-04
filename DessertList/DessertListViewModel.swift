//
//  DessertListViewModel.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 5/25/24.
//

import Foundation
import Combine

class DessertListViewModel: ObservableObject {
    
    @Published private(set) var meals = [Meal]()
    private let mealService: MealService
    private let dessertCategory = "dessert"
    private var cancellableSet = Set<AnyCancellable>()
    
    init(meals: [Meal] = [Meal](), mealService: MealService) {
        self.meals = meals
        self.mealService = mealService
        fetchMeals(for: dessertCategory)
    }
    
//    func fetchDesserts(completion: @escaping () -> () ) {
//        
//        print("fetching desserts")
//        
//        MealServices.shared.fetchMeals(for: dessertCategory) { result in
//            switch result {
//            case .failure(let error):
//                print("Error fetching meals. Error: \(error)")
//            case .success(let response):
//                self.meals = response.meals.sorted { $0.name.lowercased() < $1.name.lowercased() }
//                completion()
//                
//                
//            }
//        }
//    }
//    
    func fetchMeals(for category: String) {
        mealService.fetch(for: category)
            .receive(on: RunLoop.main)
            .sink { completion in
                guard case let .failure(error) = completion else { return }
                print("Failed to fetch meal. Error: \(error.localizedDescription)")
            } receiveValue: { [weak self] response in
                self?.meals = response.meals.sorted { $0.name.lowercased() < $1.name.lowercased()
                }
            }
            .store(in: &cancellableSet)
    }
}
