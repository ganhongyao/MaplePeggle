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

    func add(_ otherPoint: CGPoint) -> CGPoint {
        CGPoint(x: x + otherPoint.x, y: y + otherPoint.y)
    }

    func subtract(_ otherPoint: CGPoint) -> CGPoint {
        CGPoint(x: x - otherPoint.x, y: y - otherPoint.y)
    }

    func distance(to otherPoint: CGPoint) -> CGFloat {
        sqrt(
            pow(x - otherPoint.x, 2) +
            pow(y - otherPoint.y, 2)
        )
    }

    func projectOnto(axis: CGVector) -> CGFloat {
        let vector = CGVector(from: self)

        return vector.dotProduct(with: axis)
    }
}
