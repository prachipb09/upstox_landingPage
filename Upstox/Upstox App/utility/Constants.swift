//
//  Constants.swift
//  Upstox App
//
//  Created by Prachi Bharadwaj on 24/11/24.
//

import Foundation

enum ErrorMessage: LocalizedError {
    case generic
    
    var message: String {
        switch self {
            case .generic:
                return "An error occured.\n Please try again later."
        }
    }
}

public enum Environment {
    
    enum Constants {
        static let baseUrl                          = "BASE_URL"
    }
    
    private static let dict: [String: Any] = {
        guard let infoDict = Bundle.main.infoDictionary else {
            fatalError("fatal error: no plist found")
        }
        return infoDict
    }()
    
    private static func getKeyValues(keys: String) -> String {
        guard let value = Environment.dict[keys] as? String else {
            fatalError("fatal error: no such key found")
        }
        return value
    }
    
    static var baseUrl: String {
        getKeyValues(keys: Constants.baseUrl.description)
    }
}
