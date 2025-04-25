//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by R Kolos on 14.04.2025.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Properties
    private let ShowWebViewSequeIndentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?

    //MARK: - Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }

    // MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSequeIndentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError(
                    "Failed to prepare for \(ShowWebViewSequeIndentifier)")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Extension
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true, completion: nil)
        
        oauth2Service.fetchOAuthToken(code: code) { result in
            switch result {
            case .success(let token):
                OAuth2TokenStorage.storage.token = token
                self.delegate?.didAuthenticate(self)
            case .failure(let error): print("Ошибка получения токена: \(error)")
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
