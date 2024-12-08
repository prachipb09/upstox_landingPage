    //
    //  TabView.swift
    //  Upstox App
    //
    //  Created by Prachi Bharadwaj on 24/11/24.
    //

import SwiftUI

enum TabBar  {
    case watchList
    case orders
    case portflio
    case funds
    case invest
}

struct TabBarView: View {
    @State private var selectedTab: TabBar = .portflio
    var body: some View {
        VStack {
            
            TabView(selection: $selectedTab) {
                Text("WatchList")
                    .tabItem {
                        Label("Watchlist", systemImage: "list.bullet")
                    }
                    .tag(TabBar.watchList)
                Text("Orders")
                    .tabItem {
                        Label("Orders", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                    }
                    .tag(TabBar.orders)
                PortfolioScreen()
                    .tabItem {
                        Label("Portflio", systemImage: "handbag")
                    }
                    .tag(TabBar.portflio)
                Text("Funds")
                    .tabItem {
                        Label("Funds", systemImage: "indianrupeesign")
                    }
                    .tag(TabBar.funds)
                Text("Invest")
                    .tabItem {
                        Label("Invest", systemImage: "percent")
                    }
                    .tag(TabBar.invest)
            }
        }
    }
}

#Preview {
    TabBarView()
}
