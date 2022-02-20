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

    private var collisionAngle: CGFloat {
        -atan2(lineOfAction.dy, lineOfAction.dx)
    }

    private var depthOfPenetration: CGFloat {
        bodyA.radius + bodyB.radius - bodyA.center.distance(to: bodyB.center)
    }

    func resolveCollision() {
        let initialRotatedVelocityA = bodyA.velocity.rotate(by: collisionAngle)
        let initialRotatedVelocityB = bodyB.velocity.rotate(by: collisionAngle)

        var finalRotatedVelocityA: CGVector
        var finalRotatedVelocityB: CGVector

        if bodyA.isMovable {
            let massSum = bodyA.mass + bodyB.mass

            finalRotatedVelocityA = CGVector(dx: initialRotatedVelocityA.dx * (bodyA.mass - bodyB.mass) / massSum +
                                                 initialRotatedVelocityB.dx * 2 * bodyB.mass / massSum,
                                             dy: initialRotatedVelocityA.dy)

            finalRotatedVelocityB = CGVector(dx: initialRotatedVelocityB.dx * (bodyB.mass - bodyA.mass) / massSum +
                                                 initialRotatedVelocityA.dx * 2 * bodyA.mass / massSum,
                                             dy: initialRotatedVelocityA.dy)
        } else {
            finalRotatedVelocityA = initialRotatedVelocityA
            finalRotatedVelocityB = CGVector(dx: -initialRotatedVelocityB.dx,
                                             dy: initialRotatedVelocityB.dy)
        }

        finalRotatedVelocityA.dx *= bodyA.bounciness
        finalRotatedVelocityB.dx *= bodyB.bounciness

        let finalVelocityA = finalRotatedVelocityA.rotate(by: -collisionAngle)
        let finalVelocityB = finalRotatedVelocityB.rotate(by: -collisionAngle)

        bodyA.velocity = finalVelocityA
        bodyB.velocity = finalVelocityB

        let timeToMoveB = depthOfPenetration / bodyB.velocity.norm
        bodyB.updateCenter(deltaTime: timeToMoveB)

        if bodyA.isMovable {
            let timeToMoveA = depthOfPenetration / bodyA.velocity.norm
            bodyA.updateCenter(deltaTime: timeToMoveA)
        }
    }
}
