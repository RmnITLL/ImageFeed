//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by R Kolos on 16.04.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let storage = OAuth2TokenStorage()
    private let tokenKey = "oauthToken"
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard let newValue = newValue else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: tokenKey)
        }
    }
    private init() {}
}
