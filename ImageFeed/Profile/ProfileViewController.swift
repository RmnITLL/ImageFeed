//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by R Kolos on 30.03.2025.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - properties

    private var avatarImageView = UIImageView()
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLablel = UILabel()
    private var logoutButton = UIButton()


    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfile()
    }

    // MARK: - Methods

    private func userProfile() {
        avatarProfile()
        nameLabelProfile()
        logoutButtonProfile()
        loginNameLabelProfile()
        descriptionLablelProfile()
    }

    private func avatarProfile() {
        let avatar = UIImage(named: "avatar")
        let avatarImageView = UIImageView(image: avatar)

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)


        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ).isActive = true
        avatarImageView.leadingAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ).isActive = true
        self.avatarImageView = avatarImageView

    }

    private func nameLabelProfile() {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textAlignment = .left
        nameLabel.textColor = .white

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor,
                                       constant: 8).isActive = true
        nameLabel.leadingAnchor
            .constraint(equalTo: avatarImageView.leadingAnchor
        ).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -16).isActive = true
        self.nameLabel = nameLabel
    }

    private func logoutButtonProfile() {
        let logoutButton = UIButton(type: .system)

        if let exitImage = UIImage(named: "logout_button") {
            logoutButton.setImage(exitImage, for: .normal)
        }
        logoutButton.addTarget(
                            self,
                            action: #selector(didTapLogoutButton),
                            for: .touchUpInside)
                    logoutButton.tintColor = .red

        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)

        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.trailingAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -26).isActive = true
        logoutButton.centerYAnchor
            .constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        self.logoutButton = logoutButton
    }

    private func loginNameLabelProfile() {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textAlignment = .left
        loginNameLabel.textColor = .gray

        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)

        loginNameLabel.topAnchor
            .constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 8
            ).isActive = true
        loginNameLabel.leadingAnchor
            .constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.trailingAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ).isActive = true
        self.loginNameLabel = loginNameLabel
    }

    private func descriptionLablelProfile() {
        let descriptionLablel = UILabel()
        descriptionLablel.text = "Hello, world!"
        descriptionLablel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLablel.textAlignment = .left
        descriptionLablel.textColor = .white

        descriptionLablel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLablel)

        descriptionLablel.topAnchor
            .constraint(
                equalTo: loginNameLabel.bottomAnchor,
                constant: 8
            ).isActive = true
        descriptionLablel.leadingAnchor
            .constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        descriptionLablel.trailingAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ).isActive = true
        self.descriptionLablel = descriptionLablel
    }

    // MARK: - Action
    @objc
    private func didTapLogoutButton() {}
}
