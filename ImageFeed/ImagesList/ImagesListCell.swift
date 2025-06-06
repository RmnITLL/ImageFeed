//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by R Kolos on 29.03.2025.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell, CellImageProtocol {
    // MARK: - Properties
    private(set) lazy var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private(set) lazy var likeButton: UIButton = {
        let likeButton = UIButton(type: .custom)
        likeButton.isHidden = true
        likeButton.addTarget(nil, action: #selector(didTapLikeButton), for: .touchUpInside)
        likeButton.accessibilityIdentifier = "LikeButton"
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        return likeButton
    }()
    
    private(set) lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let reuseIdentifier = "ImagesListCell"
    var imageURL: URL?
    weak var delegate: CellLikeImageDelegate?
    
    // MARK: - Override Methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setCell() {
        contentView.clipsToBounds = true
        contentView.addSubview(cellImage)
        contentView.addSubview(likeButton)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: -8),
            
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellImage.trailingAnchor, constant: -8)
        ])
        contentView.backgroundColor = .ypBlack
    }
    
    func imageSetURL(from url: URL) {
        cellImage.kf.cancelDownloadTask()
        loadImage(from: url)
    }
    
    private func loadImage(from url: URL) {
        
        cellImage.contentMode = .center
        likeButton.isHidden = true
        dateLabel.isHidden = true
        
        let resource = KF.ImageResource(downloadURL: url, cacheKey: url.absoluteString)
        
        cellImage.kf.setImage(with: resource,
                              placeholder: UIImage(named: "placeholder"),
                              options: [.transition(.fade(0.3))]
        ) { result in
            switch result {
            case .success(let imageResult):
                self.likeButton.isHidden = false
                self.dateLabel.isHidden = false
                self.cellImage.contentMode = .scaleAspectFill
                self.cellImage.image = imageResult.image
            case .failure(_):
                self.cellImage.contentMode = .center
                self.likeButton.isHidden = true
                self.dateLabel.isHidden = true
            }
        }
        cellImage.kf.indicatorType = .activity
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @objc private func didTapLikeButton() {
        delegate?.cellImageLikeDidTaped(self)
    }
}
