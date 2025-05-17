//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by R Kolos on 28.04.2025.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    // MARK: - Private propertie
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    // MARK: - Static methods
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
