//
//  NewsListCell.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 25/10/1400 AP.
//

import UIKit

class NewsListCell: UITableViewCell {
    
    var item: NewsList? {
        didSet {
            configure()
        }
    }
    
    @IBOutlet private (set) weak var labelTitle: UILabel?
    @IBOutlet private (set) weak var labelAuthor: UILabel?
    @IBOutlet private (set) weak var labelDate: UILabel?
    
    private func configure() {
        labelTitle?.text = item?.title
        labelAuthor?.text = item?.author
        labelDate?.text = item?.dateString
    }
}
