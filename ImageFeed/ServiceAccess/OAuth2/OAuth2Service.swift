//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by R Kolos on 23.04.2025.
//

import Foundation

final class OAuth2Service {
    //MARK: - Static properties
    static let shared = OAuth2Service ()

    //MARK: - Private properties
    private let oAuth2TokenStorage = OAuth2TokenStorage.storage

    //MARK:  - Private methods
    func makeOAuthTokenRequest(code: String) -> Result<URLRequest, OAuthTokenRequestError> {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("ERROR: Invalid base URL")
            return.failure(.invalidBaseURL)
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            print("ERROR: Invalid URL")
            return.failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return.success(request)
    }

    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        switch makeOAuthTokenRequest(code: code) {
            case .success(let request):
                let task = URLSession.shared.data(for: request) { [weak self] result in
                    guard let self = self else { return }

                    DispatchQueue.main.async {
                        switch result {
                            case .success(let data):
                                do {
                                    let decoder = JSONDecoder()
                                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                                    self.oAuth2TokenStorage.token = response.accessToken
                                    completion(.success(response.accessToken))
                                }
                                catch {
                                    print("ERROR: Decoding error \(error.localizedDescription)")
                                    completion(.failure(NetworkError.invalidResponseData))
                                }
                            case .failure(let error):
                                print("ERROR: Network error \(error.localizedDescription)")
                                completion(.failure(error))
                        }
                    }
                }
                task.resume()
            case.failure(let error):
                print("ERROR: Request creation error \(error)")
                completion(.failure(error))
        }
    }

    //MARK: - Init
    private init(){ }
}

// MARK: - Extension
extension URLSession {
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {

        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async { completion(result) }
        }

        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("ERROR: Error status code\(statusCode), response body: \(responseString)")
                    }
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}
