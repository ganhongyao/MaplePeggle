//
//  CircularExplosionEffect.swift
//  PeggleClone
//
//  Created by Hong Yao on 23/2/22.
//

import PhysicsEngine
import CoreGraphics

class CircularExplosionEffect: Circular, GameEffect {
    private static let sizeProportionOfPeg = 2.0

    var radius: CGFloat

    var center: CGPoint

    init(radius: CGFloat, center: CGPoint) {
        self.radius = radius
        self.center = center
    }

    convenience init(from gamePeg: GamePeg) {
        self.init(radius: gamePeg.radius * CircularExplosionEffect.sizeProportionOfPeg, center: gamePeg.center)
    }

    func apply(gameBoard: GameBoard) -> Bool {
        for physicsBody in gameBoard.physicsBodies {
            guard let boardObject = physicsBody as? BoardObject else {
                continue
            }

            guard overlaps(with: boardObject) else {
                continue
            }

            if let gamePeg = physicsBody as? GamePeg, gamePeg.willActivatePowerup {
                gameBoard.gameEffects.append(CircularExplosionEffect(from: gamePeg))
                gamePeg.hasActivatedPowerup = true
            }

            physicsBody.collisionCount += 1
        }

        return true
    }
}
