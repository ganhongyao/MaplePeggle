//
//  CGPoint+Hashable.swift
//  PeggleClone
//
//  Created by Hong Yao on 29/1/22.
//

import CoreGraphics

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
