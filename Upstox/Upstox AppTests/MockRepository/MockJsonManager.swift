//
//  MockJsonManager.swift
//  Upstox App
//
//  Created by Prachi Bharadwaj on 24/11/24.
//
import Foundation

class MockJsonManager {
    func perform<T: Codable>(fileName: String, responseType: T.Type) throws -> T {
        do {
            if let path = Bundle(for: MockJsonManager.self).path(forResource: fileName, ofType: "json") {
                let url = URL(fileURLWithPath: path)
                do {
                    let data = try Data(contentsOf: url, options: .mappedIfSafe)
                    let entity = try JSONDecoder().decode(responseType, from: data)
                    return entity
                } catch {
                    throw error
                }
            } else {
                throw NSError(domain: "com.Upstox.unableToParseJson",
                              code: 500,
                              userInfo: [NSLocalizedDescriptionKey: "Unable to parse the json"])
            }
        } catch {
            throw error
        }
    }
}
