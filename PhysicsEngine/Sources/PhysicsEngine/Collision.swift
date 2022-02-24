//
//  Collision.swift
//  
//
//  Created by Hong Yao on 5/2/22.
//

import CoreGraphics

public protocol Collision {
    var bodies: (PhysicsBody, PhysicsBody) { get }

    var collisionAngle: CGFloat { get }

    var depthOfPenetration: CGFloat { get }

    func resolveCollision()
}

extension Collision {
    public func resolveCollision(bodyA: PhysicsBody, bodyB: PhysicsBody) {
        let initialRotatedVelocityA = bodyA.velocity.rotate(by: collisionAngle)
        let initialRotatedVelocityB = bodyB.velocity.rotate(by: collisionAngle)

        var finalRotatedVelocityA: CGVector
        var finalRotatedVelocityB: CGVector

        if bodyA.isKnockable && bodyB.isKnockable {
            let massSum = bodyA.mass + bodyB.mass

            finalRotatedVelocityA = CGVector(dx: initialRotatedVelocityA.dx * (bodyA.mass - bodyB.mass) / massSum +
                                                 initialRotatedVelocityB.dx * 2 * bodyB.mass / massSum,
                                             dy: initialRotatedVelocityA.dy)

            finalRotatedVelocityB = CGVector(dx: initialRotatedVelocityB.dx * (bodyB.mass - bodyA.mass) / massSum +
                                                 initialRotatedVelocityA.dx * 2 * bodyA.mass / massSum,
                                             dy: initialRotatedVelocityA.dy)
        } else if bodyA.isKnockable {
            finalRotatedVelocityA = CGVector(dx: -initialRotatedVelocityA.dx,
                                             dy: initialRotatedVelocityA.dy)
            finalRotatedVelocityB = initialRotatedVelocityB
        } else if bodyB.isKnockable {
            finalRotatedVelocityA = initialRotatedVelocityA
            finalRotatedVelocityB = CGVector(dx: -initialRotatedVelocityB.dx,
                                             dy: initialRotatedVelocityB.dy)
        } else {
            finalRotatedVelocityA = .zero
            finalRotatedVelocityB = .zero
        }

        finalRotatedVelocityA.dx *= bodyA.bounciness
        finalRotatedVelocityB.dx *= bodyB.bounciness

        let finalVelocityA = finalRotatedVelocityA.rotate(by: -collisionAngle)
        let finalVelocityB = finalRotatedVelocityB.rotate(by: -collisionAngle)

        bodyA.velocity = finalVelocityA
        bodyB.velocity = finalVelocityB

        if bodyA.isKnockable {
            let timeToMoveA = depthOfPenetration / bodyA.velocity.norm
            bodyA.updateCenter(deltaTime: timeToMoveA)
        }

        if bodyB.isKnockable {
            let timeToMoveB = depthOfPenetration / bodyB.velocity.norm
            bodyB.updateCenter(deltaTime: timeToMoveB)
        }
    }
}
