//
//  WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by R Kolos on 16.04.2025.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
