//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import UIKit

final class ImagesListPresenter: ImagePresenterProtocol {
    // MARK: - Properties
    private let imagesListService: ServiceImageProtocol
    private var imageListServiceObserver: Any?
    weak var view: ImagesViewControllerProtocol?
    var images: [WebImage] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private lazy var serverDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    init(imagesListService: ServiceImageProtocol = ServiceListImages.shared) {
        self.imagesListService = imagesListService
        setupObserver()
    }
    
    func viewDidLoad() {
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.selectImagesAnotherCell { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.updateTableViewAnimated()
            case .failure(let error):
                print("ERROR:  Error when uploading photos: \(error)")
            }
        }
    }
    
    func changeLike(photoId: String, isLike: Bool) {
        assert(Thread.isMainThread)
        print("The like button for photoId has been pressed: \(photoId)")
        UIBlockingProgressHUD.show()
        imagesListService.likeImagesChenge(photoId: photoId, isLike: isLike) { [weak self] result in
            guard let self = self else {
                UIBlockingProgressHUD.dismiss()
                return
            }
            
            switch result {
            case .success:
                self.images = self.imagesListService.images
                UIBlockingProgressHUD.dismiss()
                self.view?.updateCellLikeStatus(for: photoId)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.view?.showErrorAlert(with: "ERROR",
                                          message: "Couldn't change the like.")
                print("ERROR: Error when changing the like: \(error.localizedDescription)")
            }
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard indexPath.row < images.count else {
            print("ERROR: indexPath.row (\(indexPath.row)) goes beyond the boundaries of the array photos.count (\(images.count))")
            return
        }
        
        let photo = images[indexPath.row]
        let url = photo.thumbImageURL
        
        if let dateString = photo.createdAt, let date = serverDateFormatter.date(from: dateString) {
            cell.dateLabel.text = dateFormatter.string(from: date)
            cell.dateLabel.isHidden = false
        } else {
            cell.dateLabel.isHidden = true
        }
        
        cell.cellImage.backgroundColor = .ypGray
        cell.imageSetURL(from: url)
        
        let isLiked = photo.isLiked
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func calculateHeightForRow(at indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        guard indexPath.row < images.count else { return 0 }
        let photo = images[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / photo.size.width
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    private func setupObserver() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ServiceListImages.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = images.count
        let newCount = imagesListService.images.count
        
        if oldCount != newCount {
            let newPhotos = imagesListService.images.suffix(newCount - oldCount)
            images.append(contentsOf: newPhotos)
            
            DispatchQueue.main.async {
                self.view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
            }
        }
    }
    
    deinit {
        if let observer = imageListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
