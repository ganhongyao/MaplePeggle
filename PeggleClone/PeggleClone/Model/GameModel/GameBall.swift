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

    let isKnockable = true

    let isGravitable = true

    var center: CGPoint

    var radius: CGFloat = defaultRadius

    var velocity = CGVector.zero

    var force = CGVector.zero

    var mass: CGFloat = 1

    var bounciness: CGFloat = 0.8

    var collisionCount = 0

    var subtotalScore: Int = 0

    var numPegsHit: Int = 0

    var totalScore: Int {
        subtotalScore * numPegsHit
    }

    init(center: CGPoint) {
        self.center = center
    }
}
