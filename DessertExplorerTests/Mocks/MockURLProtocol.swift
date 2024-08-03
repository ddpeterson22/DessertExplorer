//
//  MockURLProtocol.swift
//  DessertExplorerTests
//
//  Created by Daniel Peterson on 7/29/24.
//

import Foundation
import Combine

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
  
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func stopLoading() { }

    override func startLoading() {
        // This is where you create the mock response as per your test case and send it to the URLProtocolClient.
        
        guard let handler = MockURLProtocol.requestHandler else {
          fatalError("Handler is unavailable.")
        }
          
        do {

            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}
