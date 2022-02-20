//
//  CircularPhysicsBodyImpl.swift
//  
//
//  Created by Hong Yao on 12/2/22.
//

import CoreGraphics
import PhysicsEngine

class PhysicsBodyImpl: PhysicsBody {
    var isMovable: Bool

    var velocity: CGVector

    var force: CGVector

    var mass: CGFloat

    var bounciness: CGFloat

    var collisionCount: Int

    var center: CGPoint

    init(isMovable: Bool = true, velocity: CGVector = .zero, force: CGVector = .zero, mass: CGFloat = 1.0,
         bounciness: CGFloat = 1.0, collisionCount: Int = 0, center: CGPoint = .zero) {
        self.isMovable = isMovable
        self.velocity = velocity
        self.force = force
        self.mass = mass
        self.bounciness = bounciness
        self.collisionCount = collisionCount
        self.center = center
    }

    func overlaps(with otherCircularPhysicsBody: CircularPhysicsBody) -> Bool {
        assertionFailure("This method should not be called")
        return false
    }

    func hasExceededBoundary(dimensions: CGSize, boundary: PhysicsWorldBoundary) -> Bool {
        assertionFailure("This method should not be called")
        return false
    }

    func moveWithinBoundary(dimensions: CGSize, boundary: PhysicsWorldBoundary) {
        assertionFailure("This method should not be called")
        return
    }
}
