//
//  UnsplashAPIService.swift
//  UnsplashSearcher
//
//  Created by Rexhep Kelmendi on 18.5.24.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func getImagesByQuery(query: String) -> AnyPublisher<CommonResult, Error>
}

class UnsplashApiService: APIServiceProtocol {
    func getImagesByQuery(query: String) -> AnyPublisher<CommonResult, Error> {
        let query = [URLQueryItem(name: "query", value: query),
        URLQueryItem(name: "client_id", value: clientID)]
        return request(query: query, method: .get)
    }
}
