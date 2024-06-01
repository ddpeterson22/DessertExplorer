//
//  MealServices.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 5/25/24.
//

import Foundation

// -- Tech debt considerations: Should project grow - build out URI config, organize endpoints, protocols as needed

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

extension Data {
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
