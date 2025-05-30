//
//  ImageListServiceProtocol.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import UIKit

protocol serviceImageProtocol {
    var images: [WebImage] { get }
    func likeImagesChenge(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, NetworkError>) -> Void)
    func selectImagesAnotherCell(completion: ((Result<[WebImage], Error>) -> Void)?)
}
 
