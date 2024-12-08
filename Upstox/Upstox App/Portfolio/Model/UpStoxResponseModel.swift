//
//  UpStoxResponseModel.swift
//  Upstox App
//
//  Created by Prachi Bharadwaj on 24/11/24.
//

import Foundation

// MARK: - UpStoxResponseModel
struct UpStoxResponseModel: Codable {
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let userHolding: [UserHolding]?
}

// MARK: - UserHolding
struct UserHolding: Codable, Hashable {
    let symbol: String?
    let quantity: Int?
    let ltp, avgPrice, close: Double?
}
