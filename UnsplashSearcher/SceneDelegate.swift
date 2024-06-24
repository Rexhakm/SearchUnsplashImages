//
//  SceneDelegate.swift
//  UnsplashSearcher
//
//  Created by Rexhep Kelmendi on 18.5.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let networkService = UnsplashApiService()
        window?.rootViewController = UINavigationController(rootViewController: ImagesViewController(service: networkService))
        window?.makeKeyAndVisible()
    }
}

