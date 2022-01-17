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
    
    @IBOutlet private (set) weak var imageViewIcon: UIImageView?
    @IBOutlet private (set) weak var labelTitle: UILabel?
    @IBOutlet private (set) weak var labelAuthor: UILabel?
    @IBOutlet private (set) weak var labelDate: UILabel?
    
    private func configure() {
        labelTitle?.text = item?.title
        labelAuthor?.text = item?.author
        labelDate?.text = item?.dateString
        imageViewIcon?.loadImage(with: item?.imageURL)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

private extension UIImageView {
    
    func loadImage(with url: URL?) {
        
    }
}
