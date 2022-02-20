//
//  PhysicsWorldImpl.swift
//  
//
//  Created by Hong Yao on 12/2/22.
//

import CoreGraphics
import PhysicsEngine

class PhysicsWorldImpl: PhysicsWorld {
    var physicsBodies: [PhysicsBody]

    var size: CGSize

    var passableBoundaries: Set<PhysicsWorldBoundary>

    var gravity: CGVector

    init(physicsBodies: [PhysicsBody] = [], size: CGSize = CGSize(width: 100, height: 100),
         passableBoundaries: Set<PhysicsWorldBoundary> = [], gravity: CGVector = CGVector(dx: 0, dy: 10)) {
        self.physicsBodies = physicsBodies
        self.size = size
        self.passableBoundaries = passableBoundaries
        self.gravity = gravity
    }
}
