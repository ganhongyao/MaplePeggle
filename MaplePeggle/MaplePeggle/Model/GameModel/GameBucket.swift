//
//  GameBucket.swift
//  MaplePeggle
//
//  Created by Hong Yao on 24/2/22.
//

import Foundation
import CoreGraphics
import PhysicsEngine

class GameBucket: PolygonalPhysicsBody {
    private static let defaultSize = 100.0

    var initialPosition: CGPoint {
        didSet {
            center = initialPosition
        }
    }

    let initialWidth: CGFloat = GameBucket.defaultSize

    var width: CGFloat = GameBucket.defaultSize

    var height: CGFloat = GameBucket.defaultSize

    var center: CGPoint

    var vertices: [CGPoint] {
        get {
            [CGPoint(x: center.x - width / 2, y: center.y - height / 2),
             CGPoint(x: center.x + width / 2, y: center.y - height / 2),
             CGPoint(x: center.x + width / 2, y: center.y + height / 2),
             CGPoint(x: center.x - width / 2, y: center.y + height / 2)]
        }

        // Note: Bucket vertices should not be manipulated directly
        // swiftlint:disable:next unused_setter_value
        set {}
    }

    let isMovable = true

    let isKnockable = false

    let isGravitable = false

    var velocity = CGVector(dx: 200, dy: 0)

    var force: CGVector = .zero

    var mass: CGFloat = 1.0

    var bounciness: CGFloat = 1.0

    var collisionCount = 0

    init(initialPosition: CGPoint) {
        self.initialPosition = initialPosition
        center = initialPosition
    }

    func centralize() {
        center = initialPosition
    }
}
