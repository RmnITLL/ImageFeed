//
//  WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by R Kolos on 23.04.2025.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
