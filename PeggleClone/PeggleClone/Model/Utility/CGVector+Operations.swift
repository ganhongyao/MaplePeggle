//
//  CGVector+Norm.swift
//  PeggleClone
//
//  Created by Hong Yao on 6/2/22.
//

import CoreGraphics

extension CGVector {
    init(from point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }

    var norm: CGFloat {
        hypot(dx, dy)
    }

    func scale(by factor: CGFloat) -> CGVector {
        CGVector(dx: dx * factor, dy: dy * factor)
    }

    func subtract(_ other: CGVector) -> CGVector {
        CGVector(dx: dx - other.dx, dy: dy - other.dy)
    }
}
