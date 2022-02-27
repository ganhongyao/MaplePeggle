//
//  CollisionProfiler.swift
//  PeggleClone
//
//  Created by Hong Yao on 27/2/22.
//

import PhysicsEngine

struct CollisionProfiler {
    static func isBallEnteringBucket(collision: Collision) -> Bool {
        let (bodyA, bodyB) = collision.bodies

        let involvesBallAndBucket = (bodyA is GameBucket && bodyB is GameBall) ||
                                    (bodyB is GameBucket && bodyA is GameBall)

        guard involvesBallAndBucket else {
            return false
        }

        return collision.collisionAngle == -.pi / 2
    }

    static func getLitPeg(collision: Collision) -> GamePeg? {
        let (bodyA, bodyB) = collision.bodies

        if let bodyAPeg = bodyA as? GamePeg, bodyAPeg.collisionCount == 1 {
            return bodyAPeg
        }

        if let bodyBPeg = bodyB as? GamePeg, bodyBPeg.collisionCount == 1 {
            return bodyBPeg
        }

        return nil
    }

    static func didLightPeg(collision: Collision) -> Bool {
        getLitPeg(collision: collision) != nil
    }
}
