//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import Foundation
import WebKit

final class ProfileLogout {
    private let oAuth2TokenStorage = OAuth2TokenStorage.storage
    private let imagesListService = ServiceListImages.shared
    
    static let shared = ProfileLogout()
    private init(){}
    
    func logout(){
        oAuth2TokenStorage.clearToken()
        imagesListService.cleanImageList()
        cleanCookies()
    }
    
    private func cleanCookies(){
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler:{})
            }
        }
    }
}

