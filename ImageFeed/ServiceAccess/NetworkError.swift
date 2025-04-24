//
//  NetworkError.swift
//  ImageFeed
//
//  Created by R Kolos on 24.04.2025.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidResponseData
}
