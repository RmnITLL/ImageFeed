//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by R Kolos on 30.03.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    // MARK: - Properties
    private lazy var avatarImageView: UIImageView = {
        let avatarImage = UIImage(named: "avatar")
        let avatarImageView = UIImageView(image: avatarImage)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textAlignment = .left
        nameLabel.textColor = .ypWhite
        return nameLabel
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textAlignment = .left
        loginNameLabel.textColor = .ypGray
        return loginNameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .ypWhite
        return descriptionLabel
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton(type: .system)
        if let exitImage = UIImage(named: "logout_button") {
            logoutButton.setImage(exitImage, for: .normal)
        }
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        logoutButton.tintColor = .systemRed
        return logoutButton
    }()
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Deinit
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setAvatarImageView()
        setNameLabel()
        setLoginNameLabel()
        setDescriptionLabel()
        setLogoutButton()
        updateProfileDetails()
        addProfileImageObserver()
        updateAvatar()
    }
    
    // MARK: - Override methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    // MARK: - Private Methods
    private func setAvatarImageView(){
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func setNameLabel(){
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setLoginNameLabel(){
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setDescriptionLabel(){
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setLogoutButton(){
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
    }
    
    private func updateProfileDetails() {
        if let profile = profileService.profile {
            print("Profile loaded: \(profile.name), \(profile.loginName), \(String(describing: profile.bio))")
            nameLabel.text = profile.name
            loginNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
            updateAvatar()
        } else {
            print("Профиль не загружен")
        }
    }
    
    private func updateAvatar(){
        guard let profileImageURL = ProfileImageService.shared.avatarURL, let updateUrl = URL(string: profileImageURL) else {
            print("Ошибка: avatarURL отсутствует или невалидный")
            return
        }
        print("Обновляем аватар: \(updateUrl.absoluteString)")
        avatarImageView.kf.setImage(with: updateUrl, placeholder: UIImage(named: "PlaceholderAvatar"))
    }
    
    private func addProfileImageObserver(){
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
    
    @objc private func didTapLogoutButton() {}
}
