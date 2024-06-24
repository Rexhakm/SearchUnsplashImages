//
//  Image.swift
//  UnsplashSearcher
//
//  Created by Rexhep Kelmendi on 18.5.24.
//

import Foundation

struct CommonResult: Decodable {
    let results: [Image]
}

struct Image: Identifiable, Decodable {
    var id: String
    let description: String?
    let urls: Urls
}

struct Urls: Decodable {
    let full: String
}
