//
//  DessertDetailViewModel.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 6/1/24.
//

import Foundation

class DessertDetailViewModel: ObservableObject {
    
    @Published var meal: MealDetail?
    
    func fetchMeal(with id: String, completion: @escaping () -> () ) {
        MealServices.shared.fetchMeal(with: id) { result in
            switch result {
            case .failure(let error):
                print("Failed to fetch meal. Error: \(error)")
            case .success(let response):
                self.meal = response.meals[0]
                completion()
            }
        }
    }
    
}
