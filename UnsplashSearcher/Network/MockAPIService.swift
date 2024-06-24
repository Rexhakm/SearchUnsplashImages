//
//  MockAPIService.swift
//  UnsplashSearcher
//
//  Created by Rexhep Kelmendi on 23.5.24.
//

import Foundation
import Combine

class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var images: [Image] = []
    
    func getImagesByQuery(query: String) -> AnyPublisher<CommonResult, Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        } else {
            let response = CommonResult(results: images)
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
