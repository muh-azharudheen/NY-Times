//
//  NewsApiLoaderTests.swift
//  NYTimesTests
//
//  Created by Muhammed Azharudheen on 27/10/1400 AP.
//

import Foundation

import XCTest
@testable import NYTimes

class NewsApiLoaderTests: XCTestCase {
    
    func test_initialization_doesNotRequestResponseFromServer() {
        let (_, client) = makeSUT()
        XCTAssertEqual(client.requestCount, 0, "Expected initialization doesNot Request response from server")
    }
    
    
    private func makeSUT() -> (NewsApiLoader, HttpClientSpy) {
        let client = HttpClientSpy()
        let sut = NewsApiLoader(client: client)
        return (sut, client)
    }
}

class HttpClientSpy: HTTPClient {
    
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        
    }
    
    func get<T>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        
    }
    
    
    var requestCount = 0
    
}
