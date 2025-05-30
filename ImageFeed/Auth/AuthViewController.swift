//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by R Kolos on 14.04.2025.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Properties
    private let oauth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - Lazy Properties
    private lazy var errorAlertPresenter = AlertPresenter(viewController: self)
    
    private lazy var authImageLogo: UIImageView = {
        let authImageLogo = UIImageView(image: UIImage(named: "auth_screen_logo"))
        authImageLogo.translatesAutoresizingMaskIntoConstraints = false
        return authImageLogo
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        loginButton.setTitleColor(.ypBlack, for: .normal)
        loginButton.titleLabel?.textAlignment = .center
        loginButton.backgroundColor = .ypWhite
        loginButton.layer.cornerRadius = 16
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    //MARK: - Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setBackButton()
        setAuthImageLogo()
        setLoginButton()
    }

    // MARK: - Methods
    private func setBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
    private func setAuthImageLogo() {
        view.addSubview(authImageLogo)
        NSLayoutConstraint.activate([authImageLogo.heightAnchor.constraint(equalToConstant: 60),
                                     authImageLogo.widthAnchor.constraint(equalToConstant: 60),
                                     authImageLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 236),
                                     authImageLogo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 157)])
    }
   
    private func setLoginButton() {
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([loginButton.heightAnchor.constraint(equalToConstant: 48),
                                     loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                                     loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                                     loginButton.topAnchor.constraint(equalTo: authImageLogo.bottomAnchor, constant: 300)])
    }
    
    @objc private func didTapLoginButton() {
        let webController = WebViewViewController()
        
        let helpAuth = HelpAuthication()
        let presentWebView = WebViewPresenter(authHelper: helpAuth)
        
        webController.presenter = presentWebView
        presentWebView.view = webController
        
        webController.delegate = self
        let navigationController = UINavigationController(rootViewController: webController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - Extension
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true, completion: nil)
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                OAuth2TokenStorage.storage.token = token
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("Ошибка получения токена: \(error)")
                let alertModel = AlertModel(title: "Что-то пошло не так (",
                                            message: "Не удалось войти в систему",
                                            buttonText: "OK",
                                            completion: nil,
                                            secondButtonText: nil,
                                            secondButtonCompletion: nil)
                errorAlertPresenter.showAlert(with: alertModel)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
