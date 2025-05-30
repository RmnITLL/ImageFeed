//
//  ConfigAuthication.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import Foundation

struct Authentication {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let authURLString: String
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String,
        defaultBaseURL: URL?
    )
    {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: Authentication {
        return Authentication(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: WebViewConstants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
}
