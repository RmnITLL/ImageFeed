//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by R Kolos on 23.05.2025.
//

import UIKit

final class ServiceListImages: ServiceImageProtocol {
    //MARK: - Private variables
    private(set) var images: [WebImage] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var lastLoadedPage: Int?
    private var isFetching = false
    private let oAuth2TokenStorage = OAuth2TokenStorage.storage
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    static let shared = ServiceListImages()
    private init(){}
    
    //MARK: -  Methods
     func makePhotosNextPage(token: String) -> Result<URLRequest, OAuthTokenRequestError>{
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let baseURL = Constants.defaultBaseURL else {
            print("ERROR: baseURL is missing")
            return .failure(.invalidRequest)
        }
        let photosPath = baseURL.appendingPathComponent("photos")
        var urlComponents = URLComponents(url: photosPath, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        guard let url = urlComponents?.url else {
            print("ERROR: Invalid URL PhotosNextPage")
            return .failure(.invalidRequest)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return .success(request)
    }
    
     func selectImagesAnotherCell(completion: ((Result<[WebImage], Error>) -> Void)? = nil){
        assert(Thread.isMainThread)
        guard !isFetching else { return }
        isFetching = true
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let token = oAuth2TokenStorage.token else {
            print("ERROR: The token is missing")
            isFetching = false
            return
        }
        task?.cancel()
        print("Request to download the next page with a token\(token)")
        switch makePhotosNextPage(token: token){
        case .failure(let error):
            print("ERROR: Request creation error makeProfileRequest: \(error)")
            isFetching = false
            completion?(.failure(error))
        case .success(let request):
            let task = urlSession.objectTask(for: request){ [weak self ] (result: Result<[ImageResponseResult], Error>) in
                guard let self = self else { return }
                self.isFetching = false
                switch result {
                case .success(let photoResult):
                    let newPhotos = WebImage.makeArray(from: photoResult)
                    let uniquePhotos = newPhotos.filter { newPhoto in
                        !self.images.contains { $0.id == newPhoto.id }
                    }
                    DispatchQueue.main.async {
                        self.images.append(contentsOf: uniquePhotos)
                        self.lastLoadedPage = nextPage
                        self.sentNotification()
                        completion?(.success(uniquePhotos))
                    }
                case .failure(let error):
                    print("ERROR: Error when uploading photos: \(error)")
                    completion?(.failure(error))
                }
            }
            self.task = task
            task.resume()
        }
    }
    
     func makeChangeLikeRequest(photoId: String, token: String, isLiked: Bool) -> Result<URLRequest, OAuthTokenRequestError> {
        guard let url = URL(string: "photos/\(photoId)/like", relativeTo: Constants.defaultBaseURL) else {
            print("ERROR: Invalid makeChangeLikeRequest URL")
            return.failure(.invalidBaseURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = isLiked ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return .success(request)
    }
    
     func likeImagesChenge(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard !isFetching else { return }
        isFetching = true
        guard let token = oAuth2TokenStorage.token else {
            print("ERROR: The token is missing")
            completion(.failure(.missingToken))
            isFetching = false
            return
        }
        switch makeChangeLikeRequest(photoId: photoId, token: token, isLiked: isLike){
        case .failure(let error):
            print("ERROR: Request creation error makeChangeLikeRequest: \(error)")
            completion(.failure(.urlRequestError(error)))
            isFetching = false
        case .success(let request):
            let task = urlSession.objectTask(for: request){ [weak self ] (result: Result<LikeReaction, Error>) in
                guard let self = self else { return }
                self.isFetching = false
                DispatchQueue.main.async {
                    print("JSON response: \(String(describing: result))")
                    switch result {
                    case .failure(let error):
                        print("ERROR: Network error makeProfileImageRequest: \(error.localizedDescription)")
                        completion(.failure(.urlRequestError(error)))
                    case .success:
                        if let index = self.images.firstIndex(where: {$0.id == photoId}){
                            let photo = self.images[index]
                            let newPhoto = WebImage(id: photo.id,
                                                 size: photo.size,
                                                 createdAt: photo.createdAt,
                                                 welcomeDescription: photo.welcomeDescription,
                                                 thumbImageURL: photo.thumbImageURL,
                                                 largeImageURL: photo.largeImageURL,
                                                 isLiked: !photo.isLiked)
                            
                            self.images[index] = newPhoto
                        }
                        completion(.success(()))
                    }
                }
            }
            task.resume()
        }
    }
    
     func cleanImageList(){
           images.removeAll()
           lastLoadedPage = 0
       }
    
     func sentNotification() {
        NotificationCenter.default.post(name: ServiceListImages.didChangeNotification, object: self)
    }
}

