//
//  MockUpstoxRepository.swift
//  Upstox App
//
//  Created by Prachi Bharadwaj on 24/11/24.
//
import Foundation
@testable import Upstox_App

class MockUpstoxRepositoryImpl: UpstoxRepository {
    func fetchData() async throws -> UpStoxResponseModel {
        do {
            return try MockJsonManager().perform(fileName: "UpstoxMockJson",
                                                 responseType: UpStoxResponseModel.self)
        } catch {
            throw error
        }
    }
}
