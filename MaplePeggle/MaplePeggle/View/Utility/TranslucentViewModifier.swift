//
//  TranslucentViewModifier.swift
//  MaplePeggle
//
//  Created by Hong Yao on 30/1/22.
//

import SwiftUI

struct TranslucentViewModifier: ViewModifier {
    private static let fullOpacity = 1.0
    private static let halfOpacity = 0.5

    let shouldBeTranslucent: Bool

    func body(content: Content) -> some View {
        guard shouldBeTranslucent else {
            return content.opacity(TranslucentViewModifier.fullOpacity)
        }

        return content.opacity(TranslucentViewModifier.halfOpacity)
    }
}
