//
//  NewsListViewControllerTests.swift
//  NewsListViewControllerTests
//
//  Created by Muhammed Azharudheen on 25/10/1400 AP.
//

import XCTest
@testable import NYTimes

class NewsListViewControllerTests: XCTestCase {
    
    func test_loadListCompletion_rendersSuccesfullyLoadedList() {
        
        let list0: [NewsList] = []
        
        let list1 = [NewsList(title: "title", author: "Author", imageURL: nil, dateString: "01-01-2021")]

        let list2 = [NewsList(title: "title", author: "Author", imageURL: nil, dateString: "01-01-2021"), NewsList(title: "title", author: "Author", imageURL: nil, dateString: "01-01-2021") ]

        
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
    
    func test_activityIndicator_onSuccessFullDeliveryOfItems() {
        
        let list = [NewsList(title: "title", author: "Author", imageURL: nil, dateString: "01-01-2021")]

        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.isAnimating(),"Expected to animate activity indicator view once view is loaded")
        
        loader.completeListLoading(with: list)
        
        XCTAssertFalse(sut.isAnimating(), "Expected to stop animation of activity indicator once loader completes with lists")
    }
    
    func test_activityIndicator_onFailure() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.isAnimating(),"Expected to animate activity indicator view once view is loaded")
        
        loader.completeListLoading(with: NSError(domain: "Any error", code: 0, userInfo: nil))
        
        XCTAssertFalse(sut.isAnimating(), "Expected to stop animation of activity indicator when loader fails on delivering lists")
    }
    
    func test_loadLists_showsAlertWhileCompletesWithaFailure() {
        let (sut, loader) = makeSUT()
        setAsRoot(controller: sut)
        
        sut.loadViewIfNeeded()
        loader.completeListLoading(with: NSError(domain: "Any error", code: 0, userInfo: nil))
        
        guard let alert = presentedViewController(on: sut) as? UIAlertController else {
            XCTFail("Expected to present an alert, while load fails with an error")
            return
        }
        
        XCTAssertEqual(alert.title, "Error")
        XCTAssertEqual(alert.message, "An Unknown Error Occured")
        XCTAssertEqual(alert.actions, [])
    }
    
    private func makeSUT() ->  (sut: NewsListViewController, loader: NewsListLoaderSpy) {
        let loader = NewsListLoaderSpy()
        let sut = NewsListViewController(loader: loader)
        return (sut, loader)
    }
    
    private func setAsRoot(controller: UIViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = controller
    }
    
    private func presentedViewController(on sut: UIViewController) -> UIViewController? {
        let expectation = expectation(description: "Waiting for presenting animation to complete")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        return sut.presentedViewController
    }
}

private extension NewsListViewController {
    
    func isAnimating() -> Bool {
        activityIndicatorView.isAnimating
    }

    func numberOfRenderedLists() -> Int {
        return tableView.numberOfRows(inSection: listSection)
    }

    private var listSection: Int {
        return 0
    }
}

class NewsListLoaderSpy: NewsListLoader {
        
    private var completion: ((NewsListLoader.Result) -> Void)?

    func loadList(completion: @escaping (NewsListLoader.Result) -> Void) {
        self.completion = completion
    }
    
    func completeListLoading(with list: [NewsList]) {
        completion?(.success(list))
    }
    
    func completeListLoading(with error: Error) {
        completion?(.failure(error))
    }
}
