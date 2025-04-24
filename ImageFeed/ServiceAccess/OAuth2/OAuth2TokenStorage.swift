//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by R Kolos on 23.04.2025.
//

import Foundation

final class OAuth2TokenStorage {
    static let storage = OAuth2TokenStorage()
    private let tokenKey = "oauthToken"

    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }

    private init() { }
}

