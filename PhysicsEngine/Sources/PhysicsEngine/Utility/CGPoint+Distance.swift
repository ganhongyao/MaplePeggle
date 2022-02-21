//
//  CGPoint+Distance.swift
//  PeggleClone
//
//  Created by Hong Yao on 18/1/22.
//

import CoreGraphics

extension CGPoint {
    init(from vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }

    func distance(to otherPoint: CGPoint) -> CGFloat {
        sqrt(
            pow(x - otherPoint.x, 2) +
            pow(y - otherPoint.y, 2)
        )
    }
}
