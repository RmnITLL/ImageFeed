//
//  ImagePresenterProtocol.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import UIKit

protocol ImagePresenterProtocol: AnyObject {
    var view: ImagesViewControllerProtocol? { get set }
    var images: [WebImage] { get }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool)
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func calculateHeightForRow(at indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat
}
