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
    
    func test_fetchNews_deliversSuccessFully_whenClientCompletesWithSuccessfulResponse() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Waiting for service request to complete")
        sut.fetchNews {
            if case Result.success = $0 {
                exp.fulfill()
            }
        }
        client.complete(with: emptyResponse())
        wait(for: [exp], timeout: 1)
    }
    
    func test_fetchNews_deliversFailure_whenClientCompletesWithFailureResponse() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Waiting for service request to complete")
        let error = NSError(domain: "anyError", code: 0, userInfo: nil)
        var receivedError: Error?
        sut.fetchNews {
            if case let Result.failure(error) = $0 {
                receivedError = error
                exp.fulfill()
            }
        }
        client.complete(with: error)
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(error, receivedError as NSError?, "Expected client error to be same as failure error")
    }
    
    func test_fetchNewsDeliversFailure_whenClientCompletesWithEmptyString() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Waiting for service request to complete")
        var receivedError: Error?
        sut.fetchNews {
            if case let Result.failure(error) = $0 {
                receivedError = error
                exp.fulfill()
            }
        }
        client.complete(with: "".data(using: .utf8)!)
        wait(for: [exp], timeout: 1)
        XCTAssertNotNil(receivedError, "Expected to receive an error when client completes with empty string")
    }
    
    func test_fetchNewsDeliversFailure_whenClientCompletesWithInvalidString() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Waiting for service request to complete")
        var receivedError: Error?
        sut.fetchNews {
            if case let Result.failure(error) = $0 {
                receivedError = error
                exp.fulfill()
            }
        }
        client.complete(with: invalidString())
        wait(for: [exp], timeout: 1)
        XCTAssertNotNil(receivedError, "Expected to receive an error when client completes with invalid string")
    }
    
    func test_fetchNewsDeliversNewsObject_asExpectedForSingleResponse() {
        
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Waiting for service request to complete")
        var receivedNews: [News]?
        sut.fetchNews {
            if case let Result.success(news) = $0 {
                receivedNews = news
                exp.fulfill()
            }
        }
        client.complete(with: singleResponseData())
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedNews?.count, 1, "Expected news count as 1")
    }
    
    func test_fetchNEwsDeliversManyNewsObject_onManyResponse() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Waiting for service request to complete")
        var receivedNews: [News]?
        sut.fetchNews {
            if case let Result.success(news) = $0 {
                receivedNews = news
                exp.fulfill()
            }
        }
        client.complete(with: manyResponseData(array: [0,1,2]))
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedNews?.count, 3, "Expected count for multiple response")
    }
    
    func test_dto_workingAsExpected() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Waiting for service request to complete")
        var receivedNews: [News]?
        sut.fetchNews {
            if case let Result.success(news) = $0 {
                receivedNews = news
                exp.fulfill()
            }
        }
        client.complete(with: manyResponseData(array: [0,1,2]))
        wait(for: [exp], timeout: 1)
        receivedNews?.enumerated().forEach {
            test(for: $0.element, at: $0.offset)
        }
    }
    
    // TODO: Update date formatting
    func test(for news: News, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(news.id, index, "Expected id to be same as from response")
        XCTAssertEqual(news.title, "title \(index)", "Expected Title to be same as from response")
        XCTAssertEqual(news.abstract, "abstract \(index)", "Expected Title to be same as from response")
        XCTAssertEqual(news.author, "author \(index)", "Expected Date to be empty")
    }
    
    private func emptyResponse() -> Data {
        emptyResponseString().data(using: .utf8)!
    }
    
    private func resultObject(id: Int) -> [String: Any] {
        [
            "id": id,
            "url": "https://any-url-\(id).com",
            "title": "title \(id)",
            "abstract": "abstract \(id)",
            "published_date": " ",
            "byline": "author \(id)"
        ]
    }
    
    private func responseString(idArray: [Int]) -> [String: Any] {
        let dict = idArray.map { resultObject(id: $0) }
        return ["status": "OK", "copyright": "Copyright (c) 2022 The New York Times Company.  All Rights Reserved.", "num_results": idArray.count, "results": dict
        ]
    }
    
    private func emptyResponseString() -> String {
        "{\"status\":\"OK\",\"copyright\":\"Copyright (c) 2022 The New York Times Company.  All Rights Reserved.\",\"num_results\":20,\"results\":[]}"
    }
    
    private func manyResponseData(array: [Int]) -> Data {
        guard let data = try? JSONSerialization.data(withJSONObject: responseString(idArray: array), options: .sortedKeys) else { return Data() }
        return data

    }
    
    private func singleResponseData() -> Data {
        guard let data = try? JSONSerialization.data(withJSONObject: responseString(idArray: [0]), options: .sortedKeys) else { return Data() }
        return data
    }
    
    private func invalidString() -> Data {
        "invalid String".data(using: .utf8)!
    }
    
    private func makeSUT() -> (NewsApiLoader, HttpClientSpy) {
        let client = HttpClientSpy()
        let sut = NewsApiLoader(client: client)
        return (sut, client)
    }
}


class HttpClientSpy: HTTPClient {
    
    var requestCount = 0
    var completion: ((HTTPClient.Result) -> Void)?
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        requestCount += 1
        self.completion = completion
    }
    
    func complete(with data: Data) {
        completion?(.success((data, HTTPURLResponse())))
    }
    
    func complete(with error: Error) {
        completion?(.failure(NSError(domain: "anyError", code: 0, userInfo: nil)))
    }
}
