//
//  NewsListViewModel.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 27/10/1400 AP.
//

import Foundation

class NewsListViewModel: NewsListViewModelProtocol {
    
    private let loader: NewsLoader
    private var news: [News] = []
    
    init(loader: NewsLoader) {
        self.loader = loader
    }
    
    func loadList(completion: @escaping (NewsListViewModelProtocol.Result) -> Void) {
        loader.fetchNews { [weak self] result in
            switch result {
            case .success(let news):
                self?.news = news
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func newsList(for index: Int) -> NewsList {
        return NewsList(title: "", author: "", imageURL: nil, dateString: "")
    }
    
    func numberOfLists() -> Int {
        return news.count
    }
}
