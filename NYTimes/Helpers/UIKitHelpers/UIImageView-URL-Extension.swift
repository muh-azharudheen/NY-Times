//
//  UIImageView-URL-Extension.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 27/10/1400 AP.
//

import Foundation
import SDWebImage

extension UIImageView {
    
    func loadImage(with url: URL?) {
        sd_setImage(with: url)
    }
}
