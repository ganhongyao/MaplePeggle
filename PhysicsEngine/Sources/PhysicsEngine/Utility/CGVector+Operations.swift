//
//  File.swift
//  
//
//  Created by Hong Yao on 5/2/22.
//

import CoreGraphics

extension CGVector {
    init(from point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }

    func add(_ other: CGVector) -> CGVector {
        let dx = dx + other.dx
        let dy = dy + other.dy

        return CGVector(dx: dx, dy: dy)
    }

    func subtract(_ other: CGVector) -> CGVector {
        let dx = dx - other.dx
        let dy = dy - other.dy

        return CGVector(dx: dx, dy: dy)
    }

    func rotate(by angle: CGFloat) -> CGVector {
        let dx = dx * cos(angle) - dy * sin(angle)
        let dy = self.dx * sin(angle) + dy * cos(angle)

        return CGVector(dx: dx, dy: dy)
    }

    func scale(factor: CGFloat) -> CGVector {
        CGVector(dx: dx * factor, dy: dy * factor)
    }

    func normalized() -> CGVector {
        scale(factor: 1 / norm)
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
