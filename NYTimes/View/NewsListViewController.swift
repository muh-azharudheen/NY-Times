//
//  NewsListViewController.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 25/10/1400 AP.
//

import UIKit

protocol NewsListViewModelProtocol {
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
    
    private var viewModel: NewsListViewModelProtocol
    private var datasource: [NewsList] = []
    private (set) lazy var activityIndicatorView = UIActivityIndicatorView(frame: view.frame)
    
    init(viewModel: NewsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        activityIndicatorView.startAnimating()
        loadList()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListCell") as! NewsListCell
        cell.item = datasource[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }
}

private extension NewsListViewController {
    
    func setupTableView() {
        tableView.register(UINib(nibName: "NewsListCell", bundle: .main), forCellReuseIdentifier: "NewsListCell")
    }
    
    func loadList() {
        viewModel.loadList { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            switch result {
            case .success(let lists):
                self?.didFetchLists(with: lists)
            case .failure:
                self?.didThrowError()
            }
        }
    }
    
    private func didFetchLists(with lists: [NewsList]) {
        datasource = lists
        tableView.reloadData()
    }
    
    private func didThrowError() {
        let alert = UIAlertController(title: "Error", message: "An Unknown Error Occured", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}

class DetailViewController: UIViewController { }
