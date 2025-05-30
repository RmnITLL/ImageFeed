//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by R Kolos on 14.04.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Properties
    private let authViewController = "authentication"
    private let tabBarViewController = "tabBarViewController"

    private let profileServise = ProfileService.shared
    private let storage = OAuth2TokenStorage.storage
    private lazy var showErrorAlert = AlertPresenter(viewController: self)
    
    private lazy var splashImage: UIImageView = {
        let splashImage = UIImageView(image: UIImage(named: "Vector"))
        splashImage.translatesAutoresizingMaskIntoConstraints = false
        return splashImage
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupSplashImage()
        
        if let token = storage.token {
            fetchProfile(token: token)
        } else {
            authorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.authorization()
        }
    }
    
    // MARK: - Methods
    private func setupSplashImage() {
        view.addSubview(splashImage)
        NSLayoutConstraint.activate([
            splashImage.widthAnchor.constraint(equalToConstant: 72),
            splashImage.heightAnchor.constraint(equalToConstant: 75),
            splashImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 228),
            splashImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func switchToBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        let tabBarController = TabBarController()
        print("Go on \(TabBarController.identifier)")
        window.rootViewController = tabBarController
    }
    
    private func authorization() {
        if OAuth2TokenStorage.storage.token != nil {
            print("Token authentication was successful, going to the TabBarViewController")
            switchToBarController()
        } else {
            print("Token was not found, going to the AuthViewController")
             let authViewController = AuthViewController()
                authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileServise.fetchProfile{ [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                let username = profile.userName
                ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in
                    print("fetchProfileImageURL fineshed with result: \(result)")
                }
                self.switchToBarController()
            case .failure(let error):
                print("ERROR: Error when uploading profile \(error)")
                let alertModel = AlertModel(title: "ERROR",
                                            message: "Couldn't upload profile",
                                            buttonText: "OK",
                                            completion: nil,
                                            secondButtonText: nil,
                                            secondButtonCompletion: nil)
                showErrorAlert.showAlert(with: alertModel)
            }
        }
    }
}
    
// MARK: - Extension
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = storage.token else { return }
        fetchProfile(token: token)
    }
}
