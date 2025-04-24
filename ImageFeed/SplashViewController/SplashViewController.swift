//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by R Kolos on 14.04.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: - Properties
    private let authViewController = "authentication"
    private let tabBarViewController = "tabBarViewController"
    
    //MARK: - Override Method
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.authorization()
        }
    }
    
    //MARK: - Methods
    private func switchToBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(
            withIdentifier: tabBarViewController)
        window.rootViewController = tabBarController
    }
    
    private func authorization() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if OAuth2TokenStorage.storage.token != nil {
            print("Token authentication was successful, going to the TabBarViewController")
            switchToBarController()
        } else {
            print("Token was not found, going to the AuthViewController")
            
            if let authViewController = storyboard.instantiateViewController(identifier: authViewController) as? AuthViewController {
                authViewController.delegate = self
                navigationController?.pushViewController(authViewController, animated: false)
            }
        }
    }
}
    
//MARK: - Extension
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        switchToBarController()
    }
}
