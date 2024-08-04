//
//  APIClient.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 7/30/24.
//

import Foundation
import Combine

protocol APIEndpoint {
    var base: String { get }
    var path: String { get }
    var formedURL: URL? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

protocol APIClient {
    associatedtype Endpoint: APIEndpoint
    //func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, APIError>) -> ())
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError>
}

protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
    //func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

// MARK: - Base client

class CoreAPIClient<Endpoint: APIEndpoint>: APIClient {

    // This Protocol is what connects us to the internet.  Mocking it allows us test.
    private var session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // API request with output wrapped in Publisher.  See Combine.
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        
        // config endpoint
        guard let url = endpoint.formedURL else { return Fail(error: APIError.requestFailed).eraseToAnyPublisher() }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

        return session.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.requestFailed
                }
                guard (200 ... 299).contains(response.statusCode) else {
                    throw APIError.customError(statusCode: response.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error -> APIError in
                guard let error = error as? APIError else {
                    return APIError.decodingFailed
                }
                return error
            })
            .eraseToAnyPublisher()
    }
}

// MARK: - Helpers

//struct APIResponse<T: Decodable>: Decodable {
//    let status: String
//    let data: T?
//    
//    init(status: String, data: T?) {
//        self.status = status
//        self.data = data
//    }
//}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error, Equatable {
    case requestFailed
    case decodingFailed
    case customError(statusCode: Int)
}

//extension APIResponse {
//    public var success: Bool {
//        status == "success" || status == "200"
//    }
//}
extension Data {
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
