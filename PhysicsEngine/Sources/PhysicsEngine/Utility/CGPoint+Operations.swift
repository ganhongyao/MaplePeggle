//
//  CGPoint+Distance.swift
//  PeggleClone
//
//  Created by Hong Yao on 18/1/22.
//

import CoreGraphics

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    init(from vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
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
