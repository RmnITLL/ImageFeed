//
//  webImage.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import Foundation

struct WebImage: Codable {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: URL
    let largeImageURL: URL
    var isLiked: Bool
}

extension WebImage {
    static func makeArray(from photoResults: [GeneratWebImage]) -> [WebImage] {
        return photoResults.map { result in
            WebImage(
                id: result.id,
                size: CGSize(width: result.width, height: result.height),
                createdAt: result.createdAt,
                welcomeDescription: result.description,
                thumbImageURL: result.urls.thumb,
                largeImageURL: result.urls.full,
                isLiked: result.likedByUser
            )
        }
    }
}
