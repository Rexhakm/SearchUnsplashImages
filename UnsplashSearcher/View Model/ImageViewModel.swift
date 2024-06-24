//
//  ImageViewModel.swift
//  UnsplashSearcher
//
//  Created by Rexhep Kelmendi on 23.5.24.
//

import Combine
import Foundation

class ImagesViewModel {
    private var service: APIServiceProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var images = [Image]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(service: APIServiceProtocol) {
        self.service = service
    }
    
    func getImagesByQuery(query: String) {
        guard !query.isEmpty else { return }
        
        isLoading = true
        service.getImagesByQuery(query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] status in
                self?.isLoading = false
                switch status {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                self?.images = result.results
            })
            .store(in: &subscriptions)
    }
}
