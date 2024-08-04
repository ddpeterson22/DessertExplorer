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
    private var cancellableSet = Set<AnyCancellable>()
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
    
    // Combine way
    func fetchMeal(with id: String) {
        mealService.fetchDetail(with: id)
            .receive(on: RunLoop.main)
            .sink { completion in
                guard case let .failure(error) = completion else { return }
                //self?.mealDetailStatus = .failure(message: error.localizedDescription)
                print("Failed to fetch meal. Error: \(error.localizedDescription)")
            } receiveValue: { [weak self] response in
                self?.meal = response.meals[0]
            }
            .store(in: &cancellableSet)
    }
}
