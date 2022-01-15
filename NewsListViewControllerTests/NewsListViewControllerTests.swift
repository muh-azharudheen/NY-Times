//
//  NewsListViewControllerTests.swift
//  NewsListViewControllerTests
//
//  Created by Muhammed Azharudheen on 25/10/1400 AP.
//

import XCTest
@testable import NYTimes

class NewsListViewControllerTests: XCTestCase {
    
    func test_init_doesNotFetchNews() {
        let (_, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    private func makeSUT() ->  (sut: NewsListViewController, loader: NewsListLoaderSpy) {
        let loader = NewsListLoaderSpy()
        let sut = NewsListViewController(loader: loader)
        return (sut, loader)
    }
}

class NewsListLoaderSpy: NewsListLoader {
    
    var loadCallCount = 0
    
}
