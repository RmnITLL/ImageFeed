//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by R Kolos on 28.04.2025.
//

import Foundation
import Kingfisher

final class ProfileImageService {
    // MARK: - Properties
    static let shared = ProfileImageService()
    private let oAuth2TokenStorage = OAuth2TokenStorage.storage
    private let urlSession = URLSession.shared
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    private let authConfiguration = Authentication.standard
    private var isFetching = false
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private init() {}
    
    // MARK: - Private Methods
    func makeProfileImageRequest(username: String, token: String) -> Result<URLRequest, OAuthTokenRequestError> {
        guard let url = URL(string: "users/\(username)", relativeTo: Constants.defaultBaseURL) else {
            print("ERROR: Incorrect URL ProfileImageRequest")
            return.failure(.invalidBaseURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return .success(request)
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard !isFetching else {
            return
        }
        
        isFetching = true
        
        guard let token = oAuth2TokenStorage.token else {
            print("ERROR: The token is missing")
            completion(.failure(.missingToken))
            isFetching = false
            return
        }
        
        switch makeProfileImageRequest(username: username, token: token){
        case .failure(let error):
            print("ERROR: Error creating the makeProfileImageRequest request: \(error)")
            completion(.failure(.urlRequestError(error)))
            isFetching = false
            
        case .success(let request):
            let task = urlSession.objectTask(for: request){ [weak self] (result: Result<UserResult, Error>) in
                guard let self = self else { return }
                self.isFetching = false
                
                DispatchQueue.main.async {
                    print("JSON response: \(String(describing: result))")
                    switch result {
                    case .success(let userResult):
                        print("Successful response from the API: \(userResult)")
                        print("JSON profileImage: \(String(describing: userResult.profileImage))")
                        
                        guard let profileImageURL = userResult.profileImage?.small else {
                            print("Ошибка: profileImage missing in the response API")
                            completion(.failure(.invalidResponseData))
                            return
                        }
                        print("The received avatar URL: \(profileImageURL)")
                        self.avatarURL = profileImageURL
                        
                        NotificationCenter.default.post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": profileImageURL]
                        )
                        
                        self.avatarURL = profileImageURL
                        completion(.success(profileImageURL))
                        
                    case .failure(let error):
                        print("ERROR: Network error makeProfileImageRequest: \(error.localizedDescription)")
                        completion(.failure(.urlRequestError(error)))
                    }
                }
            }
            self.task = task
            task.resume()
        }
    }
}
