//
//  PolygonalPhysicsBody.swift
//  
//
//  Created by Hong Yao on 22/2/22.
//

import CoreGraphics

public protocol PolygonalPhysicsBody: Polygonal, PhysicsBody {

}

extension PolygonalPhysicsBody {
    public func overlaps(with otherCircularPhysicsBody: CircularPhysicsBody) -> Bool {
        overlaps(with: otherCircularPhysicsBody as Circular)
    }

    public func overlaps(with otherPolygonalPhysicsBody: PolygonalPhysicsBody) -> Bool {
        overlaps(with: otherPolygonalPhysicsBody as Polygonal)
    }

    public func hasExceededBoundary(dimensions: CGSize, boundary: PhysicsWorldBoundary) -> Bool {
        switch boundary {
        case .top:
            return minY < 0
        case .bottom:
            return maxY > dimensions.height
        case .left:
            return minX < 0
        case .right:
            return maxX > dimensions.width
        }
    }

    public func moveWithinBoundary(dimensions: CGSize, boundary: PhysicsWorldBoundary) {
        guard hasExceededBoundary(dimensions: dimensions, boundary: boundary) else {
            return
        }

        let newCentroid: CGPoint

        switch boundary {
        case .top:
            newCentroid = CGPoint(x: centroid.x, y: centroid.y + (0 - minY))
        case .bottom:
            newCentroid = CGPoint(x: centroid.x, y: centroid.y - (maxY - dimensions.height))
        case .left:
            newCentroid = CGPoint(x: centroid.x + (0 - minX), y: centroid.y)
        case .right:
            newCentroid = CGPoint(x: centroid.x - (maxX - dimensions.width), y: centroid.y)
        }

        move(to: newCentroid)
    }
}
