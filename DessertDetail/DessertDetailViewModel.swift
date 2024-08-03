//
//  DessertDetailViewModel.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 6/1/24.
//

import Foundation
import Combine

class DessertDetailViewModel: ObservableObject {
    // dependencies
    private let mealService: MealService
    
    // combine boilerplate --
    private var cancellableSet: Set<AnyCancellable> = []
    // Output properties -- a way to store/organize output results to help manage state
//    enum Status: Equatable {
//        case success(meal: MealDetail)
//        case failure(message: String)
//    }
//    @Published private(set) var mealDetailStatus: Status?

    @Published private(set) var meal: MealDetail?

    
    init(mealService: MealService) {
        self.mealService = mealService
    }
    
    // Traditional way
    func fetchMeal(with id: String, completion: @escaping () -> () ) {
        mealService.fetchDetail(with: id) { result in
            switch result {
            case .failure(let error):
                print("Failed to fetch meal. Error: \(error)")
//                MealServices.shared.fetchMeal(with: id) { result2 in
//                    switch result2 {
//                    case .failure(let error):
//                        print("Failed to fetch meal. Error: \(error)")
//                    case .success(let response):
//                        self.meal = response.meals[0]
//                        completion()
//                    }
//                }
            case .success(let response):
                self.meal = response.meals[0]
                completion()
            }
        }
    }
    
    // Combine way
    func fetchMealUsingCombine(with id: String) {
        mealService.pubFetchDetail(with: id)
            .receive(on: RunLoop.main)
            .sink { completion in
                guard case let .failure(error) = completion else { return }
                //self?.mealDetailStatus = .failure(message: error.localizedDescription)
                print("Failed to fetch meal. Error: \(error.localizedDescription)")
            } receiveValue: { [weak self] response in
                guard let meal = response.data?.meals[0] else {
                    //self?.mealDetailStatus = .failure(message: "Not found")
                    print("Failed to fetch meal. Not found")
                    return
                }
                //self?.mealDetailStatus = .success(meal: meal)
                self?.meal = meal
            }
            .store(in: &cancellableSet)
    }
    
}
