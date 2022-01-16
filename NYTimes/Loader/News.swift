//
//  News.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 26/10/1400 AP.
//

import Foundation

class News {
    
    let id: String
    let title: String
    let abstract: String
    let publishedDate: Date
    let url: URL
    let imageURL: URL
    
    init(id: String, title: String, abstract: String, publishedDate: Date, url: URL, imageURL: URL) {
        self.id = id
        self.title = title
        self.abstract = abstract
        self.publishedDate = publishedDate
        self.url = url
        self.imageURL = imageURL
    }
}
