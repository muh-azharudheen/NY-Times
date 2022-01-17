//
//  NewsListViewModelTests.swift
//  NYTimesTests
//
//  Created by Muhammed Azharudheen on 27/10/1400 AP.
//

import XCTest
@testable import NYTimes

class NewsListViewModelTests: XCTestCase {
    
    func test_initialization_doesNotRequestNewsFromLoader() {
        let (_, loader) = makeSut()
        XCTAssertEqual(loader.fetchNewsCount, 0, "Expected initialization doesNot fetch News")
    }
    
    func test_loadList_requestNewsFromLoader() {
        let (sut, loader) = makeSut()
        sut.loadList { _ in }
        XCTAssertEqual(loader.fetchNewsCount, 1, "Expected loadList calls for fetching News")
    }
    
    func test_loadListCompletesWithSuccessOnSuccesfullDeliveryOfNews() {
        let (sut, loader) = makeSut()
        let exp = expectation(description: "Waiting for newsloader to complete")
        sut.loadList {
            if case Result.success = $0 {
                exp.fulfill()
            }
        }
        loader.complete(with: [])
        wait(for: [exp], timeout: 1)
    }
    
    func test_loadListCompleteWithFailureOnFailureOfNewsDelivery() {
        let (sut, loader) = makeSut()
        let exp = expectation(description: "Waiting for newsloader to complete")
        let error = NSError(domain: "anyError", code: 0, userInfo: nil)
        var receivedError: Error?
        sut.loadList {
            if case let Result.failure(error) = $0 {
                receivedError = error
                exp.fulfill()
            }
        }
        loader.complete(with: error)
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(error, receivedError as NSError?, "Expected loader error to be same as failure error")
    }
    
    func test_numberOfLists_onSuccessfullyLoadedNews() {
        
        let (sut, loader) = makeSut()
        sut.loadList { _ in }
        
        loader.complete(with: [])
        XCTAssertEqual(sut.numberOfLists(), 0, "Expected 0 items, when loader completes with empty lists")
        
        let singleNews = [makeNews(for: 0)]
        loader.complete(with: singleNews)
        XCTAssertEqual(sut.numberOfLists(), 1, "Expected 1 Item once loader complets with single news")
        
        let manyNews = [
            makeNews(for: 0),
            makeNews(for: 1),
            makeNews(for: 2)
        ]
        
        loader.complete(with: manyNews)
        XCTAssertEqual(sut.numberOfLists(), manyNews.count, "Expected number of lists same as news count")
    }
    
    func test_newsListOnSuccessfullyLoadedNews() {
        
        let (sut, loader) = makeSut()
        sut.loadList { _ in }
        
        let news0 = makeNews(for: 0)
        let news1 = makeNews(for: 1)
        let news2 = makeNews(for: 2)
        
        let singleNews = [news0]
        loader.complete(with: singleNews)
        test(news0, againist: sut.newsList(for: 0))
        
        let manyNews = [news0, news1, news2]
        loader.complete(with: manyNews)
        manyNews.enumerated().forEach {
            test($0.element, againist: sut.newsList(for: $0.offset))
        }
    }
    
    func test_urlForIndex_forRespectiveList() {
        
        let (sut, loader) = makeSut()
        sut.loadList { _ in }
        
        let news0 = makeNews(for: 0, url: URL(string: "https://any-url-0.com")!)
        let news1 = makeNews(for: 1, url: URL(string: "https://any-url-1.com")!)
        let news2 = makeNews(for: 2, url: URL(string: "https://any-url-2.com")!)
        let manyNews = [news0, news1, news2]
        loader.complete(with: manyNews)
        
        XCTAssertEqual(sut.url(for: 0).absoluteString, "https://any-url-0.com")
        XCTAssertEqual(sut.url(for: 1).absoluteString, "https://any-url-1.com")
        XCTAssertEqual(sut.url(for: 2).absoluteString, "https://any-url-2.com")
    }
    
    // MARK: Helpers
    func makeSut() -> (NewsListViewModel, NewsLoaderSpy) {
        let loader = NewsLoaderSpy()
        let sut = NewsListViewModel(loader: loader)
        return (sut, loader)
    }
    
    private  func makeNews(for index: Int, url: URL = URL(string: "https://any-url.com")!) -> News {
        News(id: index, title: "title \(index)", abstract: "abstract \(index)", author: "author \(index)", publishedDate: Date(), url: url, imageURL: nil)
    }
    
    private func test(_ news: News, againist list: NewsList, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(news.title, list.title, "Expecte list title is same as news title", file: file, line: line)
        XCTAssertEqual(news.author, list.author, "Expecte list abstract is same as news abstract", file: file, line: line)
        XCTAssertEqual(news.imageURL, list.imageURL, "Expect list abstract is same as news abstract", file: file, line: line)
        // TODO: Update checking of date
//        XCTAssertEqual(news0.publishedDate, list.dateString, "Expecte list abstract is same as news abstract")
    }
}

class NewsLoaderSpy: NewsLoader {
    
    var fetchNewsCount = 0
    var completion: ((NewsLoader.Result) -> Void)?
    
    func fetchNews(completion: @escaping (NewsLoader.Result) -> Void) {
        fetchNewsCount += 1
        self.completion = completion
    }
    
    func complete(with news: [News]) {
        completion?(.success(news))
    }
    
    func complete(with error: Error) {
        completion?(.failure(error))
    }
}
