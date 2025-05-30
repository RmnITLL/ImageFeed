//
//  ProfilePresent.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import UIKit

class AttendProfile {
    private weak var view: ProfileViewProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewProtocol) {
        self.view = view
        addProfileImageObserver()
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func viewDidLoad() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileDetails(name: profile.name, login: profile.loginName, bio: profile.bio ?? "")
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL) else {
            print("ERROR: avatarURL missing or invalid")
            return
        }
        print("Обновляем аватар: \(url.absoluteString)")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            view?.updateAvatar(with: url)
        }
    }
    
    private func addProfileImageObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
    
    func logoutTapped() {
           view?.resetToDefaultProfileData()
           logoutProfile.shared.logout()
           navigateToSplash()
       }

    private func navigateToSplash() {
        let splashViewController = SplashViewController()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = splashViewController
            window.makeKeyAndVisible()
        }
    }
}
