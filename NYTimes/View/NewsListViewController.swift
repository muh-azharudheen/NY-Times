//
//  NewsListViewController.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 25/10/1400 AP.
//

import UIKit

protocol NewsListLoader { }

class NewsListViewController: UITableViewController {
    
    private var loader: NewsListLoader
    
    init(loader: NewsListLoader) {
        self.loader = loader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
