//
//  DetailViewController.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 27/10/1400 AP.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    private let url: URL
    private (set) lazy var webView = WKWebView()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Detail"
        setupViews()
        loadRequest(with: url)
    }
    
    private func loadRequest(with url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    private func setupViews() {
        webView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
