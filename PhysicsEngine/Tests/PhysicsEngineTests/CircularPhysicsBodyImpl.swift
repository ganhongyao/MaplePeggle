//
//  CircularPhysicsBodyImpl.swift
//  
//
//  Created by Hong Yao on 12/2/22.
//

import CoreGraphics
import PhysicsEngine

class CircularPhysicsBodyImpl: CircularPhysicsBody {
    var isMovable: Bool

    var velocity: CGVector

    var force: CGVector

    var mass: CGFloat

    var bounciness: CGFloat

    var collisionCount: Int

    var center: CGPoint

    var radius: CGFloat

    init(isMovable: Bool = true, velocity: CGVector = .zero, force: CGVector = .zero, mass: CGFloat = 1.0,
         bounciness: CGFloat = 1.0, collisionCount: Int = 0, center: CGPoint = .zero, radius: CGFloat = 1.0) {
        self.isMovable = isMovable
        self.velocity = velocity
        self.force = force
        self.mass = mass
        self.bounciness = bounciness
        self.collisionCount = collisionCount
        self.center = center
        self.radius = radius
    }
}
