//
//  CGVector+Norm.swift
//  MaplePeggle
//
//  Created by Hong Yao on 6/2/22.
//

import CoreGraphics

extension CGVector {
    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    init(from point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }

    var norm: CGFloat {
        hypot(dx, dy)
    }

    func scale(by factor: CGFloat) -> CGVector {
        CGVector(dx: dx * factor, dy: dy * factor)
    }
}
