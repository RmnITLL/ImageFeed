//
//  TabBarController.swift
//  ImageFeed
//
//  Created by R Kolos on 29.04.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    // MARK: - Propertie
    static let identifier = "TabBarViewController"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagesListViewController = ImagesListViewController()
        let profileViewController = ProfileViewController()
        
        let imagesNavigationViewController = UINavigationController(rootViewController: imagesListViewController)
        imagesListViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_editorial_active"), tag: 0)
        
        let profileNavigationViewController = UINavigationController(rootViewController: profileViewController)
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_profile_active"), tag: 1)
        
        viewControllers = [imagesNavigationViewController, profileNavigationViewController]
        setTabBarController()
        setupNavigationBar(for: imagesNavigationViewController)
        setupNavigationBar(for: profileNavigationViewController)
    }
    
    // MARK: - Private Methods
    private func setTabBarController() {
        view.backgroundColor = .ypBlack
        tabBar.tintColor = .ypWhite
        tabBar.barTintColor = .ypBlack
        tabBar.unselectedItemTintColor = .ypGray
        tabBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .ypBlack
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupNavigationBar(for navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = true
    }
}
