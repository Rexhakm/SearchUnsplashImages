//
//  UnsplashSearcherTests.swift
//  UnsplashSearcherTests
//
//  Created by Rexhep Kelmendi on 18.5.24.
//

import XCTest
@testable import UnsplashSearcher
import Combine


class ImagesViewModelTests: XCTestCase {
    var viewModel: ImagesViewModel!
    var mockService: MockAPIService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        viewModel = ImagesViewModel(service: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        mockService = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetImagesByQuerySuccess() {
        let image = Image(id: "1", description: "test image", urls: Urls(full: "https://images.unsplash.com/photo-1715588561967-6d413b6690bf?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))
        mockService.images = [image]
        
        viewModel.getImagesByQuery(query: "test")
        
        let expectation = XCTestExpectation(description: "Fetch images")
        
        viewModel.$images
            .dropFirst() // Skip initial value
            .sink { images in
                XCTAssertEqual(images.count, 1)
                XCTAssertEqual(images.first?.id, "1")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetImagesByQueryFailure() {
        mockService.shouldReturnError = true
        
        viewModel.getImagesByQuery(query: "test")
        
        let expectation = XCTestExpectation(description: "Fetch images with error")
        
        viewModel.$errorMessage
            .dropFirst() // Skip initial value
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                XCTAssertEqual(errorMessage, URLError(.badServerResponse).localizedDescription)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetImagesByQueryEmptyQuery() {
        viewModel.getImagesByQuery(query: "")
        
        XCTAssertTrue(viewModel.images.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
}
