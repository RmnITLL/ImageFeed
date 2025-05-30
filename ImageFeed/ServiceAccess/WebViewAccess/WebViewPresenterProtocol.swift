//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
