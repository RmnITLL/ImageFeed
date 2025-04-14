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

    /*
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackButton()
    }
    */

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
/*
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(
            named: "nav_back_button")
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(
                named: "nav_back_button")
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
 */
}

// MARK: - Extension
extension AuthViewController: WebViewViewControllerDelegate {


    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    // TODO: process code
}

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
