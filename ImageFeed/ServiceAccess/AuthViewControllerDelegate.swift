//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by R Kolos on 16.04.2025.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
