//
//  UpstoxRepository.swift
//  Upstox App
//
//  Created by Prachi Bharadwaj on 24/11/24.
//

protocol UpstoxRepository {
    func fetchData() async throws -> UpStoxResponseModel
}

class UpstoxRepositoryImpl: UpstoxRepository {
    func fetchData() async throws -> UpStoxResponseModel {
        do {
            return try await NetworkLayer.shared.decode(modelType: UpStoxResponseModel.self, for: .landingPage)
        } catch {
            throw error
        }
    }
}
