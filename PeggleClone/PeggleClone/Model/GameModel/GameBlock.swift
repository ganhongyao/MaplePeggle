//
//  GameBlock.swift
//  PeggleClone
//
//  Created by Hong Yao on 22/2/22.
//

import Foundation
import PhysicsEngine
import CoreGraphics

class GameBlock: Block, PolygonalPhysicsBody {
    static let maxCollisionsBeforeForceRemoval = 250

    let isMovable = false

    let isKnockable = false

    let isGravitable = false

    var velocity = CGVector.zero

    var force = CGVector.zero

    var mass: CGFloat = 1

    var bounciness: CGFloat = 1

    var collisionCount = 0

    required init(id: UUID?, vertices: [CGPoint]) {
        super.init(id: id, vertices: vertices)
    }

    convenience init(from block: Block) {
        self.init(id: block.id, vertices: block.vertices)
    }

}
