//
//  SpherePolygonCollision.swift
//  
//
//  Created by Hong Yao on 22/2/22.
//

import Foundation
import CoreGraphics

struct SpherePolygonCollision: Collision {
    private let circle: CircularPhysicsBody

    private let polygon: PolygonalPhysicsBody

    let collisionAngle: CGFloat

    let depthOfPenetration: CGFloat

    init?(circle: CircularPhysicsBody, polygon: PolygonalPhysicsBody) {
        guard circle.isMovable || polygon.isMovable else {
            return nil
        }

        self.circle = circle
        self.polygon = polygon

        (self.collisionAngle, self.depthOfPenetration) =
            SpherePolygonCollision.findCollisionAngleAndPenetrationDepth(circle: circle, polygon: polygon)

        circle.collisionCount += 1
        polygon.collisionCount += 1
    }


    private static func findCollisionAngleAndPenetrationDepth(circle: CircularPhysicsBody,
                                                               polygon: PolygonalPhysicsBody) -> (CGFloat, CGFloat) {
        var collisionNormal: CGVector = .zero
        var penetrationDepth: CGFloat = .infinity

        var axes = polygon.edgeVectors.map { $0.perpendicular() }
        if let closestVertex = polygon.closestVertex(to: circle.center) {
            axes.append(CGVector(from: closestVertex.subtract(circle.center)))
        }

        for axis in axes {
            let (circleMinProjection, circleMaxProjection) = circle.getMinMaxProjectionsOntoAxis(axis: axis)
            let (polygonMinProjection, polygonMaxProjection) = polygon.getMinMaxProjectionsOntoAxis(axis: axis)

            let overlappingDepth = min(polygonMaxProjection - circleMinProjection,
                                       circleMaxProjection - polygonMinProjection)

            if overlappingDepth < penetrationDepth {
                penetrationDepth = overlappingDepth
                collisionNormal = axis.normalized()
            }
        }

        let collisionAngle = -atan2(collisionNormal.dy, collisionNormal.dx)

        return (collisionAngle, penetrationDepth)
    }

    func resolveCollision() {
        resolveCollision(bodyA: circle, bodyB: polygon)
    }

}