//
//  NewsApiLoader.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 26/10/1400 AP.
//

import Foundation

class NewsApiLoader: NewsLoader {
    
    private let client: URLSessionHTTPClient
    
    init(client: URLSessionHTTPClient) {
        self.client = client
    }
    
    func fetchNews(completion: @escaping (NewsLoader.Result) -> Void) {
        guard let url = url() else { return }
        client.get(from: url) { (result: (Result<NewsResponse, Error>)) in
            switch result {
            case .success(let response):
                let news = NewsResponse.dto(response)
                completion(.success(news))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func url() -> URL? {
        URL(string: "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=a61d05yTpaGOa3K4ffFnRUGXGNtlC840")
    }
}

private extension NewsApiLoader {
    
    struct NewsResponse: Decodable {
        
        struct NewsResult: Decodable {
            let id: Int
            let url: URL
            let title: String
            let abstract: String
            let published_date: String
        }
        
        let status: String
        let results: [NewsResult]
    }
}

private extension NewsApiLoader.NewsResponse.NewsResult {
    
    func news() -> News {
        News(id: id, title: title, abstract: abstract, publishedDate: Date(), url: url, imageURL: nil)
    }
}

private extension NewsApiLoader.NewsResponse {
    
    static func dto(_ response: NewsApiLoader.NewsResponse) -> [News] {
        response.results.map { $0.news() }
    }
}
