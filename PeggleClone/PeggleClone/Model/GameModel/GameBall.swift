//
//  GameBall.swift
//  PeggleClone
//
//  Created by Hong Yao on 4/2/22.
//

import CoreGraphics
import PhysicsEngine

class GameBall: CircularPhysicsBody {
    private static let defaultRadius: CGFloat = 25

    let isMovable = true

    var center: CGPoint

    var radius: CGFloat = defaultRadius

    var velocity = CGVector.zero

    var force = CGVector.zero

    var mass: CGFloat = 1

    var bounciness: CGFloat = 0.8

    var collisionCount = 0

    init(center: CGPoint) {
        self.center = center
    }
}
