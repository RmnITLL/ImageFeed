//
//  ImagesViewControllerProtocol.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import UIKit

protocol ImagesViewControllerProtocol: AnyObject {
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showErrorAlert(with title: String, message: String)
    func updateCellLikeStatus(for photoId: String)
}
