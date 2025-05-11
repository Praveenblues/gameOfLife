//
//  View+Extensions.swift
//  GameOfLife
//
//  Created by Praveen V on 11/05/25.
//

import SwiftUI

struct SafeAreaInsetsReader: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .environment(\.safeAreaInsets, geo.safeAreaInsets)
        }
    }
}

extension View {
    func readSafeAreaInsets() -> some View {
        self.modifier(SafeAreaInsetsReader())
    }
}
