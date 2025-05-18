//
//  UserResult.swift
//  ImageFeed
//
//  Created by R Kolos on 07.05.2025.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    struct ProfileImage: Codable {
        let small: String
        let medium: String
        let large: String
    }
}
