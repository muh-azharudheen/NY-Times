//
//  NewsApiLoader.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 26/10/1400 AP.
//

import Foundation

final class NewsApiLoader: NewsLoader {
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetchNews(completion: @escaping (NewsLoader.Result) -> Void) {
        guard let url = url() else { return }
        client.get(from: url) { (result: (Result<NewsResponse, Error>)) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let news = NewsResponse.dto(response)
                    completion(.success(news))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func url() -> URL? {
        URL(string: "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=a61d05yTpaGOa3K4ffFnRUGXGNtlC840")
    }
}

private extension NewsApiLoader {
    
    struct NewsResponse: Decodable {
        
        struct MetaData: Decodable {
            let url: URL?
        }
        
        struct Media: Decodable {
            
            let metaData: [MetaData]?
            enum CodingKeys: String, CodingKey {
                case metaData = "media-metadata"
            }
        }
        
        struct NewsResult: Decodable {
            let id: Int
            let url: URL
            let title: String
            let abstract: String
            let published_date: String
            let byline: String
            let media: [Media]?
        }
        
        let status: String
        let results: [NewsResult]
    }
}

private extension NewsApiLoader.NewsResponse.NewsResult {
    
    func news() -> News {
        News(id: id, title: title, abstract: abstract, author: byline, publishedDate: dateFrom(published_date), url: url, imageURL: media?.first?.metaData?.first?.url)
    }
    
    private func dateFrom(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-DD"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString) ?? Date()
    }
}

private extension NewsApiLoader.NewsResponse {
    
    static func dto(_ response: NewsApiLoader.NewsResponse) -> [News] {
        response.results.map { $0.news() }
    }
}
