//
//  MealServices.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 5/25/24.
//

import Foundation
import Combine

protocol MealService {
    // Traditional way
    func fetch(for category: String, completion: @escaping (Result<MealResponse, APIError>) -> ())
    func fetchDetail(with id: String, completion: @escaping (Result<MealDetailResponse, APIError>) -> ())
    // Combine's new way -- wrapping result in Publisher
    func pubFetch(for category: String) -> AnyPublisher<APIResponse<MealResponse>, APIError>
    func pubFetchDetail(with id: String) -> AnyPublisher<APIResponse<MealDetailResponse>, APIError>
}

class MealServiceProvider: MealService {
    
    private let apiClient = CoreAPIClient<MealEndpoint>()
    init() {}
    
    func fetch(for category: String, completion: @escaping (Result<MealResponse, APIError>) -> ()) {
        apiClient.request(.fetch(category: category), completion: completion)
    }
    
    func fetchDetail(with id: String, completion: @escaping (Result<MealDetailResponse, APIError>) -> ()) {
        apiClient.request(.fetchDetail(id: id), completion: completion)
    }
    
    func pubFetch(for category: String) -> AnyPublisher<APIResponse<MealResponse>, APIError> {
        return apiClient.requestPubbed(.fetch(category: category))
    }
    
    func pubFetchDetail(with id: String) -> AnyPublisher<APIResponse<MealDetailResponse>, APIError> {
        return apiClient.requestPubbed(.fetchDetail(id: id))
    }
}

class MealServices: ObservableObject {
    
    static let shared = MealServices()
    
    // -- API: mealdb
    
    func fetchMeal(with id: String, completion: @escaping (Result<MealDetailResponse, Error>) -> () ) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        fetchData(urlString: urlString, completion: completion)
    }
    
    func fetchMeals(for category: String, completion: @escaping (Result<MealResponse, Error>) -> () ) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)"
        fetchData(urlString: urlString, completion: completion)
    }
    
    fileprivate func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> () ) {
        guard let url = URL(string: urlString) else { return }
        print("\(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            guard let data = data else { return }
            
            do {
                let decoded: T = try data.decoded()
                
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            }
            catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}
