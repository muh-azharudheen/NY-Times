//
//  DetailViewControllerTests.swift
//  NYTimesTests
//
//  Created by Muhammed Azharudheen on 27/10/1400 AP.
//

import XCTest
@testable import NYTimes
import WebKit

class DetailViewControllerTests: XCTestCase {
    
    func test_doesNotLoadWebViewOnInitialization() {
        let sut = makeSUT()
        XCTAssertFalse(sut.isWebViewLoading(), "Expected not to start request before view is loaded")
    }
    
    func test_startLoadingWebViewOnceViewIsLoaded() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isWebViewLoading(), "Expected to start loading request once view is loaded")
    }
    
    private func makeSUT() -> DetailViewController {
        return DetailViewController(url: URL(string: "https://any-url.com)")!)
    }
}

private extension DetailViewController {
    
    func isWebViewLoading() -> Bool {
        webView.isLoading
    }
}
