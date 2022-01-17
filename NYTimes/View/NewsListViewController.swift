//
//  NewsListViewController.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 25/10/1400 AP.
//

import UIKit

protocol NewsListViewModelProtocol {
    typealias Result = Swift.Result<Void, Error>
    func loadList(completion: @escaping (Result) -> Void)
    func newsList(for index: Int) -> NewsList
    func numberOfLists() -> Int
    func url(for index: Int) -> URL
}

struct NewsList {
    let title: String
    let author: String
    let imageURL: URL?
    let dateString: String
}

class NewsListViewController: UITableViewController {
    
    private var viewModel: NewsListViewModelProtocol
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
        return viewModel.numberOfLists()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.item = viewModel.newsList(for: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(url: viewModel.url(for: indexPath.row))
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

private extension NewsListViewController {
    
    func setupTableView() {
        tableView.registerNib(NewsListCell.self)
    }
    
    func loadList() {
        viewModel.loadList { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            switch result {
            case .success:
                self?.tableView.reloadData()
            case .failure:
                self?.didThrowError()
            }
        }
    }
    
    private func didThrowError() {
        let alert = UIAlertController(title: "Error", message: "An Unknown Error Occured", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}
