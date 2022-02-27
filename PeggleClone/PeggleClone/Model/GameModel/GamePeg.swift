//
//  GamePeg.swift
//  PeggleClone
//
//  Created by Hong Yao on 4/2/22.
//

import Foundation
import CoreGraphics
import PhysicsEngine

class GamePeg: Peg, CircularPhysicsBody {
    static let maxCollisionsBeforeForceRemoval = 50

    let isMovable = false

    let isKnockable = false

    let isGravitable = false

    var velocity = CGVector.zero

    var force = CGVector.zero

    var mass: CGFloat = 1

    var bounciness: CGFloat = 1

    var collisionCount = 0

    var hasActivatedPowerup = false

    var willActivatePowerup: Bool {
        isPowerup && hasCollided && !hasActivatedPowerup
    }

    required init(center: CGPoint, radius: CGFloat, color: Peg.Color, id: UUID?, facingAngle: CGFloat = .zero) {
        super.init(center: center, radius: radius, color: color, id: id, facingAngle: facingAngle)
    }

    convenience init(from peg: Peg) {
        self.init(center: peg.center, radius: peg.radius, color: peg.color, id: peg.id, facingAngle: peg.facingAngle)
    }
}
