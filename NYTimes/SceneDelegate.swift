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
        window.rootViewController = initialViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func initialViewController() -> UIViewController {
        UIViewController()
    }
}
