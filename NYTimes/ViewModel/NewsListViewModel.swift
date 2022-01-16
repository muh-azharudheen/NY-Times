//
//  NewsListViewModel.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 27/10/1400 AP.
//

import Foundation

class NewsListViewModel: NewsListViewModelProtocol {
    
    private let loader: NewsLoader
    
    init(loader: NewsLoader) {
        self.loader = loader
    }
    
    func loadList(completion: @escaping (NewsListViewModelProtocol.Result) -> Void) {
        
    }
    
    func newsList(for index: Int) -> NewsList {
        return NewsList(title: "", author: "", imageURL: nil, dateString: "")
    }
    
    func numberOfLists() -> Int {
        return 0
    }
}
