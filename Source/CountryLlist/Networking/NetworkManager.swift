//
//  NetworkManager.swift
//  CountryList
//
//  Created by Saravanakumaran Sakthivel on 3/17/24.
//

import Foundation

// Create Network error enum
enum NetworkError: Error {
    case genericError
    case parsingError
    case noData
    case httpError
    case notValidURL
}

// HTTP Method enum type
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

// Network request strut
struct NetworkRequest {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Data?
}

// Basic networking interface that helps to call web service using URLSession.
protocol Networking {
    func performRequest(networkRequest: NetworkRequest) async throws -> Result<Data, NetworkError>
}

class NetworkManager {
    // Define a singleton, This helps to protect not modify Network manager configuration.
    /// This will be helpfiul when we are trying to define cache size and policies and other extra configuration.
    private static var sharedMgr: NetworkManager = {
        let networkMgr = NetworkManager()
        return networkMgr
    }()
    
    let urlSession = URLSession(configuration: .default)
    
    private init() {
        
    }
    
    class func shared() -> NetworkManager {
        return sharedMgr
    }
    
}


extension NetworkManager: Networking {
    // Service call implementation using URLSession with async.
    //TODO: If we know the exact status code and its defined meaning, we can leverage this code and get more acurete state.
    func performRequest(networkRequest: NetworkRequest) async throws -> Result<Data, NetworkError> {
        let urlRequest = URLRequest(url: networkRequest.url)
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            return .failure(NetworkError.httpError)
        }
        if data.isEmpty {
            return .failure(NetworkError.noData)
        }
        return .success(data)
    }
}
