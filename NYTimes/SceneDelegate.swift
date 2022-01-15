//
//  SceneDelegate.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 24/10/1400 AP.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let viewController = initialViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func initialViewController() -> UIViewController {
        NewsListViewController(loader: NewsListApiLoader())
    }
}

class NewsListApiLoader: NewsListLoader {
    
    func loadList(completion: @escaping (NewsListLoader.Result) -> Void) {
        completion(.success([ NewsList(title: "Title", author: "Author", imageURL: nil, dateString: "01-01-2021") ]))
    }
}
