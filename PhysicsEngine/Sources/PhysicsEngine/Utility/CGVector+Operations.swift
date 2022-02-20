//
//  File.swift
//  
//
//  Created by Hong Yao on 5/2/22.
//

import CoreGraphics

extension CGVector {
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

    var norm: CGFloat {
        hypot(dx, dy)
    }
}
