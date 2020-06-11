//
//  API.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/26.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation

let Default_Count: Int = 80

protocol APIProviderProtocol {
    associatedtype Model
    func fetchImageList<Model: Codable>(_ type: Model.Type, completion: @escaping (Result<Model, API.APIError>) -> ())
}

extension API {
    enum APIError: Error {
        case invalidJSON
        case invalidURL
        case noData
        case etc(localizedString: String)
    }
    
    enum APISort: String {
        case accuracy
        case recency
    }
}

enum API: APIProviderProtocol {
    typealias Model = RootModel
    
    case imageUrl(text: String, page: Int, sort: APISort, size: Int)
    
    private var baseURLString: String {
        return "https://dapi.kakao.com/v2"
    }
    
    private var urlString: String {
        switch self {
        case .imageUrl(_, _, _, _):
            return "\(baseURLString)/search/image"
        }
    }
    
    // Authorization
    private var httpAdditionalHeaders: [String: String] {
        switch self {
        case .imageUrl(_, _, _, _):
            return ["Authorization": "KakaoAK 5a831e9e500d0d4faf2e2ab1094caf45"]
        }
    }
    
    private var parameters: [String: Any] {
        switch self {
        case .imageUrl(let text, let page, let sort, let size):
            return [
                "query": text,
                "page": page,
                "sort": sort.rawValue,
                "size": size
            ]
        }
    }
    
    
    // MARK: - fetching
    
    func fetchImageList<T: Codable>(_ type: T.Type, completion: @escaping (Result<T, APIError>) -> ()) {
        // Paramters
        var urlComponents: URLComponents = URLComponents(string: urlString)!
        let queryItems: [URLQueryItem] = self.parameters.map {
            let value: String
            if $0.value is String {
                value = $0.value as! String
            }
            else {
                value = "\($0.value)"
            }
            return URLQueryItem(name: $0.key, value: value)
        }
        urlComponents.queryItems = queryItems
        
        // URL
        print("urlComponents.url = \(urlComponents.url?.absoluteString ?? "nil")")
        guard let url: URL = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.httpAdditionalHeaders = self.httpAdditionalHeaders
        
        // Network
        let urlSession: URLSession = URLSession(configuration: configuration)
        urlSession.dataTask(with: url) { (data, response, error) in
//            print("response = \(String(describing: response))")
//            print("error = \(String(describing: error))")
            guard error == nil else {
                completion(.failure(.etc(localizedString: error?.localizedDescription ?? "")))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode else {
                    completion(.failure(.etc(localizedString: response.debugDescription)))
                    return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
//            let json: String = String(data: data, encoding: .utf8) ?? ""
//            print("json = \(json)")
            if let rootModel: T = try? JSONDecoder().decode(type, from: data) {
                completion(.success(rootModel))
            }
            else {
                completion(.failure(.invalidJSON))
            }
        }.resume()
    }
}
