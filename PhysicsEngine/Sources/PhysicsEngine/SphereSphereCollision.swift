//
//  SphereSphereCollision.swift
//  
//
//  Created by Hong Yao on 5/2/22.
//

import CoreGraphics

/// Represents a colliison between two circular physics bodies.
/// Body B will always be movable, while Body A may or may not be movable.
public struct SphereSphereCollision: Collision {
    public var bodies: (PhysicsBody, PhysicsBody) {
        (bodyA, bodyB)
    }

    let bodyA: CircularPhysicsBody

    let bodyB: CircularPhysicsBody

    init(bodyA: CircularPhysicsBody, bodyB: CircularPhysicsBody) {
        self.bodyA = bodyA
        self.bodyB = bodyB

        bodyA.collisionCount += 1
        bodyB.collisionCount += 1
    }

    private var lineOfAction: CGVector {
        let positionVectorA = CGVector(dx: bodyA.center.x, dy: bodyA.center.y)
        let positionVectorB = CGVector(dx: bodyB.center.x, dy: bodyB.center.y)

        return positionVectorB - positionVectorA
    }

    public var collisionAngle: CGFloat {
        -atan2(lineOfAction.dy, lineOfAction.dx)
    }

    public var depthOfPenetration: CGFloat {
        bodyA.radius + bodyB.radius - bodyA.center.distance(to: bodyB.center)
    }

    public func resolveCollision() {
        resolveCollision(bodyA: bodyA, bodyB: bodyB)
    }
}
