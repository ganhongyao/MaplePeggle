//
//  SphereSphereCollision.swift
//  
//
//  Created by Hong Yao on 5/2/22.
//

import CoreGraphics

/// Represents a colliison between two circular physics bodies.
/// Body B will always be movable, while Body A may or may not be movable.
struct SphereSphereCollision: Collision {
    private let bodyA: CircularPhysicsBody

    private let bodyB: CircularPhysicsBody

    /// Initializer fails when neither bodies are movable, since there cannot be a collision in the first place.
    init?(bodyA: CircularPhysicsBody, bodyB: CircularPhysicsBody) {
        guard bodyA.isMovable || bodyB.isMovable else {
            return nil
        }

        // Guarantees that at least bodyB is movable (bodyA can be immovable)
        self.bodyB = bodyB.isMovable ? bodyB : bodyA
        self.bodyA = self.bodyB === bodyB ? bodyA : bodyB

        bodyA.collisionCount += 1
        bodyB.collisionCount += 1
    }

    private var lineOfAction: CGVector {
        let positionVectorA = CGVector(dx: bodyA.center.x, dy: bodyA.center.y)
        let positionVectorB = CGVector(dx: bodyB.center.x, dy: bodyB.center.y)

        return positionVectorB.subtract(positionVectorA)
    }

    var collisionAngle: CGFloat {
        -atan2(lineOfAction.dy, lineOfAction.dx)
    }

    var depthOfPenetration: CGFloat {
        bodyA.radius + bodyB.radius - bodyA.center.distance(to: bodyB.center)
    }

    func resolveCollision() {
        resolveCollision(bodyA: bodyA, bodyB: bodyB)
    }
}
