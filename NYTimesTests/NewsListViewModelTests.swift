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
    
    private  func makeNews(for index: Int) -> News {
        return News(id: index, title: "title \(index)", abstract: "abstract \(index)", publishedDate: Date(), url: URL(string: "www.google.com")!, imageURL: nil)
    }
    
    func makeSut() -> (NewsListViewModel, NewsLoaderSpy) {
        let loader = NewsLoaderSpy()
        let sut = NewsListViewModel(loader: loader)
        return (sut, loader)
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
}
