//
//  NewsListViewControllerTests.swift
//  NewsListViewControllerTests
//
//  Created by Muhammed Azharudheen on 25/10/1400 AP.
//

import XCTest
@testable import NYTimes

class NewsListViewControllerTests: XCTestCase {
    
    func test_init_doesNotFetchList() {
        let (_, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected No Load request before view is loaded")
    }
    
    func test_loadList_whenViewIsLoaded() {
        
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1, "Expect a loading request once view is loaded")
    }
    
    private func makeSUT() ->  (sut: NewsListViewController, loader: NewsListLoaderSpy) {
        let loader = NewsListLoaderSpy()
        let sut = NewsListViewController(loader: loader)
        return (sut, loader)
    }
}

class NewsListLoaderSpy: NewsListLoader {
    
    var loadCallCount = 0

    func loadList(completion: @escaping (NewsListLoader.Result) -> Void) {
        loadCallCount += 1
    }
}
