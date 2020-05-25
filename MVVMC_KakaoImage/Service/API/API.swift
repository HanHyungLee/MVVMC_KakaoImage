//
//  API.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/26.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation

extension API {
    enum APIError: Error {
        case invalidJSON
        case noData
        case etc(localizedString: String)
    }
}

enum API {
    case imageUrl
    
    private var urlString: URL? {
        switch self {
        case .imageUrl:
            return URL(string: "https://dapi.kakao.com/v2/search/image")!
        @unknown default:
            return nil
        }
    }
    
    // Authorization
    private var httpAdditionalHeaders: [String: String] {
        switch self {
        case .imageUrl:
            return ["Authorization": "KakaoAK 5a831e9e500d0d4faf2e2ab1094caf45"]
        default:
            return [:]
        }
    }
    
    
    // MARK: - fetching
    
    func fetchImageList(text: String, page: Int, completion: (Result<RootModel, APIError>) -> ()) {
        guard let url: URL = self.urlString else {
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.httpAdditionalHeaders = self.httpAdditionalHeaders
        
        let urlSession: URLSession = URLSession(configuration: configuration)
        urlSession.dataTask(with: url) { (data, response, error) in
            print("data = \(String(describing: data))")
            print("response = \(String(describing: response))")
            print("error = \(String(describing: error))")
            if error != nil {
                completion(.failure(.etc(localizedString: error?.localizedDescription ?? "")))
            }
            else {
                if let data = data {
                    if let rootModel: RootModel = try? JSONDecoder().decode(RootModel.self, from: data) {
                        completion(.success(rootModel))
                    }
                    else {
                        completion(.failure(.invalidJSON))
                    }
                }
                else {
                    completion(.failure(.noData))
                }
            }
        }.resume()
    }
}
