//
//  NetworkLayer.swift
//  Upstox App
//
//  Created by Prachi Bharadwaj on 24/11/24.
//

import Foundation

enum UpstoxError: Error {
    case NetworkError
}

enum UpstoxHTTPSMethods: String, Equatable {
    case get = "GET"
    case post = "POST"
}

enum RequestType {
    case landingPage
    
    var httpMethod: UpstoxHTTPSMethods {
        switch self {
            case .landingPage:
                    .get
        }
    }
}

class NetworkLayer {
    static let shared = NetworkLayer()
    
    private init() { }
    
    func decode<T: Codable>(modelType: T.Type, for dataType: RequestType) async throws -> T {
        guard let url = URL(string: "\(Environment.baseUrl)" ) else {
            throw UpstoxError.NetworkError
        }
        
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .returnCacheDataElseLoad,
                                    timeoutInterval: 10.0)
        urlRequest.httpMethod = dataType.httpMethod.rawValue
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let values =  try JSONDecoder().decode(modelType, from: data)
            return values
        } catch {
            throw error
        }
    }
}
