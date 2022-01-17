//
//  NewsListViewControllerTests.swift
//  NewsListViewControllerTests
//
//  Created by Muhammed Azharudheen on 25/10/1400 AP.
//

import XCTest
@testable import NYTimes

class NewsListViewControllerTests: XCTestCase {
    
    func test_loadNews_doesNotCallOnInitialization() {
        let (_, viewModel) = makeSUT()
        XCTAssertEqual(viewModel.loadNewsCount, 0, "Expected no calls to load on initialization")
    }
    
    func test_loadNews_willBeInvokedOnceViewIsLoaded() {
        let (sut, viewModel) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(viewModel.loadNewsCount, 1, "Expected Load News function invoked on viewDidload")
    }
    
    func test_loaderStartAnimatingOnceViewIsLoaded() {
        let (sut, _) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isAnimating(), "Expected to show loader once view is loaded")
    }
    
    func test_loader_behaviouronSuccesfullyDeliverOfLists() {
        
        let testList = [NewsList(title: "title", author: "Author", imageURL: nil, dateString: "01-01-2021")]
        
        let (sut, viewModel) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isAnimating(), "Expected to show loader once view is loaded")
        
        viewModel.completeListLoading(with: testList)
        
        XCTAssertFalse(sut.isAnimating(), "Expected to stop animating once loading lists delivers items")
    }
    
    func test_loader_behaviouronFailureOfLoadingLists() {
        
        let (sut, viewModel) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isAnimating(), "Expected to show loader once view is loaded")
        
        viewModel.completeListLoading(with: NSError(domain: "anyError", code: 0, userInfo: nil))
        
        XCTAssertFalse(sut.isAnimating(), "Expected to stop animating once loading lists fails")
    }
    
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
    
    func test_cell_onSuccessfullLoadingOfNews() {

        let list0 = NewsList(title: "title1", author: "Author1", imageURL: nil, dateString: "01-01-2022")
        let list1 = NewsList(title: "title2", author: "Author2", imageURL: nil, dateString: "01-01-2022")
        let list2 = NewsList(title: "title3", author: "Author3", imageURL: nil, dateString: "01-01-2022")

        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        loader.completeListLoading(with: [list0, list1, list2])

        test(cell: sut.cell(for: 0) as? NewsListCell, with: list0)
        test(cell: sut.cell(for: 1) as? NewsListCell, with: list1)
        test(cell: sut.cell(for: 2) as? NewsListCell, with: list2)
    }
    
    func test_selecting_list_willNavigateToDetailViewController() {
        let (sut, loader) = makeSUT()
        let navigationController = UINavigationController(rootViewController: sut)
        setAsRoot(controller: navigationController)
        
        let list0 = NewsList(title: "title1", author: "Author1", imageURL: nil, dateString: "01-01-2022")
        loader.completeListLoading(with: [list0])
        
        sut.simulateTapOnList(at: 0)
        waitForScreenChangeAnimation()
        
        XCTAssertNotNil(navigationController.children.last as? DetailViewController)
    }
    
    private func makeSUT() -> (sut: NewsListViewController, viewModel: NewsListViewModelSpy) {
        let viewModel = NewsListViewModelSpy()
        let sut = NewsListViewController(viewModel: viewModel)
        return (sut, viewModel)
    }
    
    private func test(cell: NewsListCell?, with list: NewsList, file: StaticString = #filePath, line: UInt = #line) {
        guard let cell = cell else {
            XCTFail("Expected cell with type NewsListCell", file: file, line: line)
            return
        }
        XCTAssertEqual(cell.labelTitle?.text, list.title, file: file, line: line)
        XCTAssertEqual(cell.labelAuthor?.text, list.author, file: file, line: line)
        XCTAssertEqual(cell.labelDate?.text, list.dateString, file: file, line: line)
    }
    
    private func setAsRoot(controller: UIViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = controller
    }
    
    private func presentedViewController(on sut: UIViewController) -> UIViewController? {
        waitForScreenChangeAnimation()
        return sut.presentedViewController
    }
    
    private func waitForScreenChangeAnimation() {
        let expectation = expectation(description: "Waiting for presenting animation to complete")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}

private extension NewsListViewController {
    
    func cell(for index: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: index, section: listSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    func isAnimating() -> Bool {
        activityIndicatorView.isAnimating
    }

    func numberOfRenderedLists() -> Int {
        return tableView.numberOfRows(inSection: listSection)
    }

    private var listSection: Int {
        return 0
    }
    
    func simulateTapOnList(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: listSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
}

private extension NewsListViewControllerTests {
    
    class NewsListViewModelSpy: NewsListViewModelProtocol {

        var lists = [NewsList]()
        
        var loadNewsCount = 0
        
        func numberOfLists() -> Int {
            lists.count
        }
            
        private var completion: ((NewsListViewModelProtocol.Result) -> Void)?
        var selectedIndex: Int?

        func loadList(completion: @escaping (NewsListViewModelProtocol.Result) -> Void) {
            loadNewsCount += 1
            self.completion = completion
        }
        
        func newsList(for index: Int) -> NewsList {
            lists[index]
        }
        
        func completeListLoading(with list: [NewsList]) {
            lists = list
            completion?(.success(()))
        }
        
        func completeListLoading(with error: Error) {
            completion?(.failure(error))
        }
        
        func url(for index: Int) -> URL {
            return URL(string: "https://any-url.com")!
        }
    }
}
