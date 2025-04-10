//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by R Kolos on 29.03.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Properties
    static let reuseIdentifier = "ImagesListCell"

    // MARK: - Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        cellSize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Methods
    private func cellSize() {
        cellImage.layer.masksToBounds = true
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = UIColor(named: "YP White")
    }
}

