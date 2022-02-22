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
    private static let maxCollisionsBeforeForceRemoval = 50

    let isMovable = false

    var velocity = CGVector.zero

    var force = CGVector.zero

    var mass: CGFloat = 1

    var bounciness: CGFloat = 1

    var collisionCount = 0

    var hasExceededMaxCollisions: Bool {
        collisionCount > GamePeg.maxCollisionsBeforeForceRemoval
    }

    required init(id: UUID?, center: CGPoint, radius: CGFloat, facingAngle: CGFloat = .zero, color: Peg.Color,
                  parentBoard: Board? = nil) {
        super.init(id: id, center: center, radius: radius, facingAngle: facingAngle, color: color,
                   parentBoard: parentBoard)
    }

    convenience init(from peg: Peg) {
        self.init(id: peg.id, center: peg.center, radius: peg.radius, facingAngle: peg.facingAngle, color: peg.color,
                  parentBoard: peg.parentBoard)
    }
}
