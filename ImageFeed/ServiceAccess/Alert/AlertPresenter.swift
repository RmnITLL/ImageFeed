//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by R Kolos on 08.05.2025.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
   
    func showAlert(with model: AlertModel) {
        let alert = UIAlertController (title: model.title,
                                       message: model.message,
                                       preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
