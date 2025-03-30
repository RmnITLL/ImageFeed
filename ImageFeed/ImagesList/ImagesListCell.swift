//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by R Kolos on 29.03.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {

    // MARK: IBOutlet
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: properties
    static let reuseIdentifier = "ImagesListCell"
}

