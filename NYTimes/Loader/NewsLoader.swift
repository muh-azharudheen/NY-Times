//
//  NewsLoader.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 26/10/1400 AP.
//

import Foundation

protocol NewsLoader {
    typealias Result = Swift.Result<News, Error>
    func fetchNews(from url: URL, completion: @escaping (Result) -> Void)
}
