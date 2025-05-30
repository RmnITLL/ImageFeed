//
//  AlertModel.swift
//  ImageFeed
//
//  Created by R Kolos on 08.05.2025.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
    
    let secondButtonText: String?
    let secondButtonCompletion:(() -> Void)?
    
    var hasSecondButton: Bool {
        return secondButtonText != nil
    }
}
