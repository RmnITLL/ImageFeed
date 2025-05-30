//
//  WebViewControllerProtocol.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import Foundation

protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
