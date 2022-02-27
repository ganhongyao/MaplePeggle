//
//  CGPoint+Offset.swift
//  PeggleClone
//
//  Created by Hong Yao on 25/2/22.
//

import CoreGraphics

extension CGPoint {
    // swiftlint:disable:next identifier_name
    func offset(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        CGPoint(x: self.x + x, y: self.y + y)
    }

    func offset(vector: CGVector) -> CGPoint {
        CGPoint(x: x + vector.dx, y: y + vector.dy)
    }
}
