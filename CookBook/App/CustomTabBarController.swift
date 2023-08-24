//
//  CustomTabBarController.swift
//  CookBook
//
//  Created by Sergey on 06.03.2023.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        modalPresentationStyle = .automatic
        modalTransitionStyle = .crossDissolve
        
        let popularNavigationController = UINavigationController(rootViewController: PopularViewController())
        let favoritesNavigationController = UINavigationController(rootViewController: FavoriteViewController())
        let searchNavigationController = UINavigationController(rootViewController: SearchViewController())
        setViewControllers([popularNavigationController, favoritesNavigationController, searchNavigationController,], animated: false)
        
        customizeTabBar(popularNavigationController, name: "Popular")
        customizeTabBar(favoritesNavigationController, name: "Favorites")
        customizeTabBar(searchNavigationController, name: "Search")
    }
}

private extension CustomTabBarController {
    func customizeTabBar(_ controller: UINavigationController, name: String) {
        controller.viewControllers[0].title = name
        
        switch name {
        case "Popular":
            controller.tabBarItem.image = UIImage(systemName: "star.square")
            controller.tabBarItem.selectedImage = UIImage(systemName: "star.square.fill")
            
            controller.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
            controller.navigationBar.prefersLargeTitles = true
            controller.navigationItem.largeTitleDisplayMode = .automatic
            
            if #available(iOS 13.0, *) {
                let navBarApp: UINavigationBarAppearance = UINavigationBarAppearance()
                navBarApp.configureWithDefaultBackground()
                if #available(iOS 15.0, *) {
                    UINavigationBar.appearance().scrollEdgeAppearance = navBarApp
                }
            }
            guard let tabBar = controller.tabBarController?.tabBar else {
                print("ERROR: TabBar is not present (nil)")
                return
            }
            
            tabBar.tintColor = .systemGreen
            tabBar.layer.cornerRadius = 25
            tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            tabBar.layer.masksToBounds = true
            
            if #available(iOS 13.0, *) {
                let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                if #available(iOS 15.0, *) {
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                }
            }
            
        case "Favorites":
            controller.tabBarItem.image = UIImage(systemName: "heart")
            controller.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
            
        case "Search":
            controller.tabBarItem.image = UIImage(systemName: "magnifyingglass")
            controller.tabBarItem.selectedImage = UIImage(systemName: "plus.magnifyingglass")
            controller.navigationBar.prefersLargeTitles = true
            controller.navigationItem.largeTitleDisplayMode = .automatic
        default:
            print("Undefined case")
            break
        }
    }
}
