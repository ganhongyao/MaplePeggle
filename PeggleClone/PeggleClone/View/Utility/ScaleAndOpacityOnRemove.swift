//
//  ScaleAndOpacityTransition.swift
//  PeggleClone
//
//  Created by Hong Yao on 25/2/22.
//

import SwiftUI

extension AnyTransition {
    static func scaleAndOpacityOnRemove(scaleFactor: CGFloat) -> AnyTransition {
        AnyTransition.asymmetric(insertion: .identity,
                                 removal: .scale(scale: scaleFactor)
                                    .combined(with: .opacity))
    }
}
