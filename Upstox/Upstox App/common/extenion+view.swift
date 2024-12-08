//
//  OnLoad.swift
//  Upstox App
//
//  Created by Prachi Bharadwaj on 24/11/24.
//

import SwiftUI

extension View {
    @ViewBuilder func onLoad(action: @escaping () -> Void) -> some View {
        modifier(OnLoad(action: action))
    }
}

struct OnLoad: ViewModifier {
    @State var isLoaded = false
    let action: () -> Void
    func body(content: Content) -> some View {
        content.onAppear {
            if !isLoaded {
                isLoaded = true
                action()
            }
        }
    }
}
