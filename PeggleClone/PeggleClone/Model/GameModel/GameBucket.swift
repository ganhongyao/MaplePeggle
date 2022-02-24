//
//  GameBucket.swift
//  PeggleClone
//
//  Created by Hong Yao on 24/2/22.
//

import Foundation
import CoreGraphics
import PhysicsEngine

class GameBucket: PolygonalPhysicsBody {
    private static let defaultHeight = 100.0

    var minYCoordinate: CGFloat

    var width: CGFloat = defaultHeight

    var height: CGFloat = defaultHeight {
        didSet {
            center = CGPoint(x: center.x, y: minYCoordinate + height / 2)
        }
    }

    var center: CGPoint

    var vertices: [CGPoint] {
        get {
            [CGPoint(x: center.x - width / 2, y: center.y - height / 2),
             CGPoint(x: center.x + width / 2, y: center.y - height / 2),
             CGPoint(x: center.x + width / 2, y: center.y + height / 2),
             CGPoint(x: center.x - width / 2, y: center.y + height / 2)]
        }

        set {
            assertionFailure("Bucket vertices should not be manipulated directly")
        }
    }

    var isMovable = false

    var velocity: CGVector = .zero

    var force: CGVector = .zero

    var mass: CGFloat = 1.0

    var bounciness: CGFloat = 1.0

    var collisionCount = 0

    init(xCoordinate: CGFloat, minYCoordinate: CGFloat) {
        self.center = CGPoint(x: xCoordinate, y: minYCoordinate + GameBucket.defaultHeight / 2)
        self.minYCoordinate = minYCoordinate
    }
}
