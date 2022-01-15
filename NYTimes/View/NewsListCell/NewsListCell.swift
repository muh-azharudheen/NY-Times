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
            labelTitle?.text = item?.title
            labelAuthor?.text = item?.author
            labelDate?.text = item?.dateString
        }
    }
    
    @IBOutlet weak var labelTitle: UILabel?
    @IBOutlet weak var labelAuthor: UILabel?
    @IBOutlet weak var labelDate: UILabel?
}
