    //
    //  ContentView.swift
    //  Upstox App
    //
    //  Created by Prachi Bharadwaj on 24/11/24.
    //

import SwiftUI

enum PortfolioViewType {
    case holding
    case positions
}

struct PortfolioScreen: View {
    @State private var showLoader: Bool = false
    @State private var showErrorView: Bool = false
    @State private var showPLSheet: Bool = false
    @State private var viewState: PortfolioViewType = .holding
    
    @StateObject private var viewModel: PortfolioViewModel = PortfolioViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            profileBannerView()
            
            portfolioOptionsView()
            
            Divider()
                .frame(height: 1)
                .overlay(.gray.opacity(0.7))
            
            if viewState == .holding {
                holdingsDetailView()
                userPNLDetailsView()
            } else {
                positionsView()
            }
        }
        .onLoad {
            fetchData()
        }
        .alert(isPresented: $showErrorView, content: {
            Alert(title: Text(ErrorMessage.generic.message))
        })
        .showLoader(showLoader)
        .refreshable {
            fetchData()
        }
    }
    
    @ViewBuilder
    private func portfolioTypeCTA(title: String,
                          isActive: Bool,
                          action: @escaping ()-> Void) -> some View {
        Button {
            action()
        } label: {
            VStack {
                Text(title)
                Divider()
                    .frame(height: 1)
                    .overlay(isActive ? .black : .gray)
                    .padding(.horizontal, 36)
            }
        }
        .foregroundStyle(isActive ? .black : .gray)
    }
    
    @ViewBuilder
    private func portfolioOptionsView() -> some View {
        HStack {
            portfolioTypeCTA(title: "POSITIONS",
                             isActive: viewState == .positions) {
                viewState = .positions
            }
            portfolioTypeCTA(title: "HOLDINGS",
                             isActive: viewState == .holding) {
                viewState = .holding
            }
            
        }.padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private func positionsView() -> some View {
        VStack {
            Spacer()
        }
    }
    
    @ViewBuilder
    private func holdingsDetailView() -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                if let userHoldings = viewModel.model?.data?.userHolding {
                    ForEach(userHoldings, id: \.self) { value in
                        stockDetailsCellView(value)
                    }
                }
            }.padding(.all, 16.0)
        }
    }
    
    @ViewBuilder
    private func profileBannerView() -> some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "person.circle")
            Text("Portfolio")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            Image(systemName: "arrow.up.arrow.down")
            Divider()
                .frame(height: 32)
                .background(.white)
            Image(systemName: "magnifyingglass")
        }
        .bold()
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .foregroundStyle(.white)
        .background(Color.accentColor)
    }
    
    @ViewBuilder
    private func profitLossCellView(keyName: String,
                                    keyValue: Double,
                                    shouldHighlight: Bool = false) -> some View {
        HStack {
            Text(keyName)
                .font(.subheadline)
            Spacer()
            if shouldHighlight {
                profitLossText(amount: keyValue)
            } else {
                Text("₹\(String(format: "%.2f", keyValue))")
                    .foregroundStyle(.black)
            }
        }
    }
    
    @ViewBuilder
    private func stockDetailsCellView(_ userHoldingDetail: UserHolding) -> some View {
        VStack(alignment: .leading) {
            VStack(spacing: 16) {
                HStack(alignment: .center) {
                    Text(userHoldingDetail.symbol ?? "")
                        .font(.headline)
                    
                    Spacer()
                    Text("LTP: ₹\(String(format: "%.2f", userHoldingDetail.ltp ?? .zero))")
                        .font(.subheadline)
                }
                
                HStack(alignment: .center) {
                    HStack {
                        Text("NET QTY: ")
                            .foregroundStyle(.gray)
                        Text("\(userHoldingDetail.quantity ?? 0)")
                            .bold()
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Text("P&L:")
                        .foregroundStyle(.gray)
                    
                    profitLossText(amount: viewModel.calculatePNL(userDetails: userHoldingDetail))
                }
            }
            Divider()
                .foregroundStyle(.black)
        }
    }
    
    @ViewBuilder private func profitLossText(amount: Double) -> some View {
        if amount >= 0 {
            Text("₹\(String(format: "%.2f", amount))")
                .font(.headline)
                .foregroundStyle(.green)
        } else {
            Text("-₹\(String(format: "%.2f", abs(amount)))")
                .font(.headline)
                .foregroundStyle(.red)
        }
    }
    
    @ViewBuilder
    private func userPNLDetailsView() -> some View {
        VStack(spacing: 12.0) {
            if showPLSheet {
                VStack(spacing: 24.0) {
                    profitLossCellView(keyName: "Current value*",
                                       keyValue: viewModel.currentSum)
                    profitLossCellView(keyName: "Total investment*",
                                       keyValue: viewModel.totalInvestment)
                    profitLossCellView(keyName: "Today's Profit & Loss*",
                                       keyValue: viewModel.todaysPNL,
                                       shouldHighlight: true)
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(.gray)
                }
            }
            
            HStack {
                HStack {
                    Text("Profit & Loss*")
                    Button {
                        showPLSheet.toggle()
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                }
                
                Spacer()
                
                profitLossText(amount: viewModel.totalPNL)
                
            }
        }.padding(.all, 16)
            .foregroundStyle(.black)
            .background(
                Rectangle()
                    .foregroundStyle(.gray.opacity(0.2))
                    .cornerRadius(8.0))
    }
    
    private func fetchData() {
        Task {
            do {
                showLoader = true
                try await viewModel.fetchData()
            } catch {
                showErrorView = true
            }
            showLoader = false
        }
    }
}

#Preview {
    PortfolioScreen()
}
