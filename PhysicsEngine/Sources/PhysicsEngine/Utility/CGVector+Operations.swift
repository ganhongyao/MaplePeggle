//
//  File.swift
//  
//
//  Created by Hong Yao on 5/2/22.
//

import CoreGraphics

extension CGVector {
    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    static func * (vector: CGVector, factor: CGFloat) -> CGVector {
        CGVector(dx: vector.dx * factor, dy: vector.dy * factor)
    }

    init(from point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }

    func rotate(by angle: CGFloat) -> CGVector {
        let dx = dx * cos(angle) - dy * sin(angle)
        let dy = self.dx * sin(angle) + dy * cos(angle)

        return CGVector(dx: dx, dy: dy)
    }

    func normalized() -> CGVector {
        self * (1 / norm)
    }

    func perpendicular() -> CGVector {
        CGVector(dx: -dy, dy: dx)
    }

    func dotProduct(with other: CGVector) -> CGFloat {
        dx * other.dx + dy * other.dy
    }

    var norm: CGFloat {
        hypot(dx, dy)
    }
}
