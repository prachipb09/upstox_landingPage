//
//  UpstoxViewModel.swift
//  Upstox App
//
//  Created by Prachi Bharadwaj on 24/11/24.
//

import SwiftUI

@MainActor
class PortfolioViewModel: ObservableObject {
    @Published var model: UpStoxResponseModel?
    
    init(model: UpStoxResponseModel? = nil) {
        self.model = model
    }
    
    var currentSum: Double {
        var currentValue = 0.0
        if let userHolding = model?.data?.userHolding {
            for value in userHolding { 
                currentValue += (value.ltp ?? 0.0 * Double(value.quantity ?? 0))
            }
        }
        return currentValue
    }
    
    var totalInvestment: Double {
        var totalInvestment = 0.0
        if let userHolding = model?.data?.userHolding {
            for value in userHolding {
                totalInvestment += (value.avgPrice ?? 0.0 * Double(value.quantity ?? 0))
            }
        }
        return totalInvestment
    }
    
    var totalPNL: Double {
        currentSum - totalInvestment
    }
    
    var todaysPNL: Double {
        var todaysPNL = 0.0
        if let userHolding = model?.data?.userHolding {
            for value in userHolding {
                let perday = (value.close ?? 0.0 * Double(value.quantity ?? 0)) - (value.ltp ?? 0.0 * Double(value.quantity ?? 0))
                todaysPNL += perday
            }
        }
        return Double(todaysPNL) 
    }
    
    func calculatePNL(userDetails: UserHolding)-> Double {
        ((userDetails.ltp ?? 0.0) * Double(userDetails.quantity ?? 0)) - ((userDetails.avgPrice ?? 0.0) * Double(userDetails.quantity ?? 0))
     
    }
    
    func fetchData(repository: UpstoxRepository = UpstoxRepositoryImpl()) async throws {
        do {
            model = try await repository.fetchData()
        } catch {
            throw error
        }
    }
}
