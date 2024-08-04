//
//  MealEndpoint.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 8/1/24.
//

import Foundation

enum MealEndpoint: APIEndpoint {
    case fetch(category: String)
    case fetchDetail(id: String)
    
        // MARK: - config
    
    // Note on Developer practices: While some might argue that breaking a URL into Apple's provided URL components is the way to go, the following approach illustrates practicality over formality.;  Creating a URL from two concatenated strings, as opposed to even more components, is more productive.
    
    var base: String {
        return "https://www.themealdb.com"
    }

    var path: String {
        switch self {
        case let .fetchDetail(id):
            return "/api/json/v1/1/lookup.php?i=\(id)"
        case let .fetch(category):
            return "/api/json/v1/1/filter.php?c=\(category)"
        }
    }
    
    var formedURL: URL? {
        let structure = base + path
        return URL(string: structure)
    }

    var method: HTTPMethod {
        switch self {
        case .fetch, .fetchDetail:
            return .get
        }
    }

    var headers: [String: String]? {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        return headers
    }
     // MARK: - requests
    var body: Data? {
        switch self {
        case .fetch:
//  example body code -- for POST
//            let requestBody = MealRequestBody(category: category)
//            return try? JSONEncoder().encode(requestBody)
            return nil
        case .fetchDetail:
            return nil
        }
    }
}
