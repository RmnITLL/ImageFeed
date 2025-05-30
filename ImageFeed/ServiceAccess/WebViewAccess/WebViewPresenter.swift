//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    var authHelper: HelpAuthicationProtocol
    
    init(authHelper: HelpAuthicationProtocol = HelpAuthication()) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard let request = authHelper.requestAuthication() else { return }
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.urlComponents(from: url)
    }
}

