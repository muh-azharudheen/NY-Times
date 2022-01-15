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
    
    func test_loadListCompletion_rendersSuccesfullyLoadedList() {
        
        let list0: [NewsListViewController.List] = []
        
        let list1 = [NewsListViewController.List(title: "title", author: "Author", imageURL: nil, dateString: "01-01-2021")]

        let list2 = [NewsListViewController.List(title: "title", author: "Author", imageURL: nil, dateString: "01-01-2021"), NewsListViewController.List(title: "title", author: "Author", imageURL: nil, dateString: "01-01-2021") ]

        
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        // view is loaded
        XCTAssertEqual(sut.numberOfRenderedLists(), 0, "Expected Empty List once view is Loaded")
        
        // complete lists successfully
        loader.completeListLoading(with: list0)
        XCTAssertEqual(sut.numberOfRenderedLists(), 0, "Expected empty list when loader completes with empty list")
        
        // complete lists successfully
        loader.completeListLoading(with: list1)
        XCTAssertEqual(sut.numberOfRenderedLists(), 1, "Expected single list when loader completes with a single list")
        
        // complete lists successfully
        loader.completeListLoading(with: list2)
        XCTAssertEqual(sut.numberOfRenderedLists(), list2.count, "Expected list counts when loader completes with many lists")
    }
    
    private func makeSUT() ->  (sut: NewsListViewController, loader: NewsListLoaderSpy) {
        let loader = NewsListLoaderSpy()
        let sut = NewsListViewController(loader: loader)
        return (sut, loader)
    }
}

private extension NewsListViewController {

    func numberOfRenderedLists() -> Int {
        return tableView.numberOfRows(inSection: listSection)
    }

    private var listSection: Int {
        return 0
    }
}

class NewsListLoaderSpy: NewsListLoader {
    
    var loadCallCount = 0
    
    private var completion: ((NewsListLoader.Result) -> Void)?

    func loadList(completion: @escaping (NewsListLoader.Result) -> Void) {
        loadCallCount += 1
        self.completion = completion
    }
    
    func completeListLoading(with list: [NewsListViewController.List]) {
        completion?(.success(list))
    }
}
