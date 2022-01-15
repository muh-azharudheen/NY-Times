//
//  NewsListViewController.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 25/10/1400 AP.
//

import UIKit

protocol NewsListLoader {
    typealias Result = Swift.Result<[NewsList], Error>
    func loadList(completion: @escaping (Result) -> Void)
}

struct NewsList {
    let title: String
    let author: String
    let imageURL: URL?
    let dateString: String
}

class NewsListViewController: UITableViewController {
    
    private var loader: NewsListLoader
    private var datasource: [NewsList] = []
    private (set) lazy var activityIndicatorView = UIActivityIndicatorView(frame: view.frame)
    
    init(loader: NewsListLoader) {
        self.loader = loader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewsListCell", bundle: .main), forCellReuseIdentifier: "NewsListCell")
        activityIndicatorView.startAnimating()
        loadList()
    }
    
    private func loadList() {
        loader.loadList { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            switch result {
            case .success(let lists):
                self?.datasource = lists
                self?.tableView.reloadData()
            case .failure:
                let alert = UIAlertController(title: "Error", message: "An Unknown Error Occured", preferredStyle: .alert)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListCell") as! NewsListCell
        cell.item = datasource[indexPath.row]
        return cell
    }
}
