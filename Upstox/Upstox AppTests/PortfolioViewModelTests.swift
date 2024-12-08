//
//  Upstox_AppTests.swift
//  Upstox AppTests
//
//  Created by Prachi Bharadwaj on 24/11/24.
//

import XCTest
@testable import Upstox_App

@MainActor
final class PortfolioViewModelTests: UpstoxTestCase {
    var viewModel: PortfolioViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = PortfolioViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNil(viewModel.model)
    }
    
    func testCurrentSumCalculation() async {
        GIVEN("User has the holdings")
        WHEN("User has the stocks to check the current sum")
        do {
            try await viewModel.fetchData(repository: MockUpstoxRepositoryImpl())
            THEN("The current sum should be available for the stocks")
            XCTAssertEqual(viewModel.currentSum, 23510.550000000003)
        } catch {
            XCTFail("failed to fetch data")
        }
    }
    
    func testTotalInvestmentCalculation() async {
        GIVEN("User has the holdings")
        WHEN("User has the stocks to check the total investment")
        do {
            try await viewModel.fetchData(repository: MockUpstoxRepositoryImpl())
            THEN("The total investment should be available for the stocks")
            XCTAssertEqual(viewModel.totalInvestment, 22766.1)
        } catch {
            XCTFail("failed to fetch data")
        }
    }
    
    func testTotalPNLCalculation() async {
        GIVEN("User has the holdings")
        WHEN("User has to check total profit and loss for the stocks")
        do {
            try await viewModel.fetchData(repository: MockUpstoxRepositoryImpl())
            THEN("The total profit and loss should be available for the stocks")
            XCTAssertEqual(viewModel.totalPNL, 744.4500000000044)
        } catch {
            XCTFail("failed to fetch data")
        }
    }
    
    func testTodaysPNLCalculation() async {
        GIVEN("User has the holdings")
        do {
            WHEN("User has to check today's total profit and loss for the stocks")
            try await viewModel.fetchData(repository: MockUpstoxRepositoryImpl())
            THEN("The today's profit and loss should be available for the stocks")
            XCTAssertEqual(viewModel.todaysPNL, -33.200000000000045)
        } catch {
            XCTFail("failed to fetch data")
        }
    }
    
    func testCalculatePNL() {
        GIVEN("User has the holdings")
        WHEN("User has to check today's total profit and loss for the particular stock")
        let userHolding = UserHolding(symbol: "ICICI", quantity: 100, ltp: 150.0, avgPrice: 100.0, close: 120)
        THEN("The today's profit and loss should be available")
        XCTAssertEqual(viewModel.calculatePNL(userDetails: userHolding), 5000.0)
    }
    
    func testFetchData() async {
        GIVEN("User enters the portfolio page")
        try? await viewModel.fetchData(repository: MockUpstoxRepositoryImpl())
        XCTAssertNotNil(viewModel.model)
    }
}
