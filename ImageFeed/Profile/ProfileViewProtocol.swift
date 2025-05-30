//
//  ProfileViewProtocol.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
    func updateProfileDetails(name: String, login: String, bio: String)
    func updateAvatar(with url: URL)
    func resetToDefaultProfileData()
}
