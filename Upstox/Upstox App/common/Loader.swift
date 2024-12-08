//
//  Loader.swift
//  Upstox App
//
//  Created by Prachi Bharadwaj 24/11/24.
//


import SwiftUI

struct Loader: ViewModifier {
    var showLoader: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if showLoader {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
    }
}

extension View {
    @ViewBuilder func showLoader(_ showLoader: Bool) -> some View {
        modifier(Loader(showLoader: showLoader))
    }
}
