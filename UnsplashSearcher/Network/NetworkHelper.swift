//
//  NetworkHelper.swift
//  UnsplashSearcher
//
//  Created by Rexhep Kelmendi on 18.5.24.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
}

private let host = "api.unsplash.com"

func request<T: Decodable>(query: [URLQueryItem],
                        method: HTTPMethod) -> AnyPublisher<T, Error> {
    
    var compenents = URLComponents()
    compenents.scheme = "https"
    compenents.host = host
    compenents.path = "/search/photos"
    compenents.queryItems = query
        
    let url = compenents.url!
    return URLSession.shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}
