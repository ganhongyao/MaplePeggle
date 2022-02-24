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

    private var initialXCoordinate: CGFloat

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

        }
    }

    let isMovable = true

    let isKnockable = false

    let isGravitable = false

    var velocity = CGVector(dx: 200, dy: 0)

    var force: CGVector = .zero

    var mass: CGFloat = 1.0

    var bounciness: CGFloat = 1.0

    var collisionCount = 0

    init(initialXCoordinate: CGFloat, minYCoordinate: CGFloat) {
        self.initialXCoordinate = initialXCoordinate
        self.minYCoordinate = minYCoordinate
        center = CGPoint(x: initialXCoordinate, y: minYCoordinate + GameBucket.defaultHeight / 2)
    }

    func centralize() {
        center.x = initialXCoordinate
    }
}
