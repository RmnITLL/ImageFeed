//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import Foundation

protocol HelpAuthicationProtocol {
    func requestAuthication() -> URLRequest?
    func urlComponents(from url: URL) -> String?
}
