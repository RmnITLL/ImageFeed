//
//  OAuthTokenRequestError.swift
//  ImageFeed
//
//  Created by R Kolos on 16.04.2025.
//

import Foundation

enum OAuthTokenRequestError: Error {
    case invalidBaseURL
    case invalidURL
    case invalidRequest
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidResponseData
    case missingToken
    case requestFailed
}

enum ImagesListServiceError: Error {
    case missingToken
    case urlRequestError(Error)
}
