//
//  CircularPhysicsBody.swift
//  PeggleClone
//
//  Created by Hong Yao on 18/1/22.
//

import CoreGraphics

public protocol CircularPhysicsBody: CircularObject, PhysicsBody {

}

extension CircularPhysicsBody {
    public func overlaps(with otherCircularPhysicsBody: CircularPhysicsBody) -> Bool {
        overlaps(with: otherCircularPhysicsBody as CircularObject)
    }

    public func hasExceededBoundary(dimensions: CGSize, boundary: PhysicsWorldBoundary) -> Bool {
        switch boundary {
        case .top:
            return center.y - radius < 0
        case .bottom:
            return center.y + radius > dimensions.height
        case .left:
            return center.x - radius < 0
        case .right:
            return center.x + radius > dimensions.width
        }
    }

    public func moveWithinBoundary(dimensions: CGSize, boundary: PhysicsWorldBoundary) {
        guard hasExceededBoundary(dimensions: dimensions, boundary: boundary) else {
            return
        }

        switch boundary {
        case .top:
            center.y = radius
        case .bottom:
            center.y = dimensions.height - radius
        case .left:
            center.x = radius
        case .right:
            center.x = dimensions.width - radius
        }
    }
}
