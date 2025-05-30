//
//  HelpAuthication.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import UIKit

class HelpAuthication: HelpAuthicationProtocol {
    
    let authConfig: Authentication
    
    init(congiguration: Authentication = .standard) {
        self.authConfig = congiguration
    }
    
    func requestAuthication() -> URLRequest? {
        guard let url = authURL() else { return nil }
        return URLRequest(url: url)
    }
    
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: authConfig.authURLString) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: authConfig.accessKey),
            URLQueryItem(name: "redirect_uri", value: authConfig.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: authConfig.accessScope)
        ]
        return urlComponents.url
    }
    
    func urlComponents(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" }) {
            return codeItem.value
        }
        return nil
    }
}
