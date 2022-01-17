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
    
    func test_fetchNews_RequestResponseFromServer() {
        let (sut, client) = makeSUT()
        sut.fetchNews(completion: { _ in })
        XCTAssertEqual(client.requestCount, 1, "Expected fetching news requests response from server")
    }
    
    
    private func makeSUT() -> (NewsApiLoader, HttpClientSpy) {
        let client = HttpClientSpy()
        let sut = NewsApiLoader(client: client)
        return (sut, client)
    }
}

class HttpClientSpy: HTTPClient {
    
    var requestCount = 0
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        requestCount += 1
    }
}
