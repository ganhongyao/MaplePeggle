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

        var (finalRotatedVelocityA, finalRotatedVelocityB) = calculateFinalVelocitiesAlongNormal(
            bodyA: bodyA, velocityAlongNormalA: initialRotatedVelocityA,
            bodyB: bodyB, velocityAlongNormalB: initialRotatedVelocityB
        )

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

    private func calculateFinalVelocitiesAlongNormal(bodyA: PhysicsBody,
                                                     velocityAlongNormalA: CGVector,
                                                     bodyB: PhysicsBody,
                                                     velocityAlongNormalB: CGVector) -> (CGVector, CGVector) {
        let finalVelocityAlongNormalA: CGVector
        let finalVelocityAlongNormalB: CGVector

        if bodyA.isKnockable && bodyB.isKnockable {
            let massSum = bodyA.mass + bodyB.mass

            finalVelocityAlongNormalA = CGVector(dx: velocityAlongNormalA.dx * (bodyA.mass - bodyB.mass) / massSum +
                                                 velocityAlongNormalB.dx * 2 * bodyB.mass / massSum,
                                                 dy: velocityAlongNormalA.dy)

            finalVelocityAlongNormalB = CGVector(dx: velocityAlongNormalB.dx * (bodyB.mass - bodyA.mass) / massSum +
                                                 velocityAlongNormalA.dx * 2 * bodyA.mass / massSum,
                                                 dy: velocityAlongNormalA.dy)
        } else if bodyA.isKnockable {
            finalVelocityAlongNormalA = CGVector(dx: -velocityAlongNormalA.dx,
                                                 dy: velocityAlongNormalA.dy)
            finalVelocityAlongNormalB = velocityAlongNormalB
        } else if bodyB.isKnockable {
            finalVelocityAlongNormalA = velocityAlongNormalA
            finalVelocityAlongNormalB = CGVector(dx: -velocityAlongNormalB.dx,
                                                 dy: velocityAlongNormalB.dy)
        } else {
            finalVelocityAlongNormalA = .zero
            finalVelocityAlongNormalB = .zero
        }

        return (finalVelocityAlongNormalA, finalVelocityAlongNormalB)
    }
}
