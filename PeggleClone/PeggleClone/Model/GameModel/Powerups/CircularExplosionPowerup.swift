//
//  CircularExplosionPowerup.swift
//  PeggleClone
//
//  Created by Hong Yao on 23/2/22.
//

import PhysicsEngine
import CoreGraphics

class CircularExplosionPowerup: Circular, Powerup {
    private static let sizeProportionOfPeg = 2.0

    var radius: CGFloat

    var center: CGPoint

    init(radius: CGFloat, center: CGPoint) {
        self.radius = radius
        self.center = center
    }

    convenience init(from gamePeg: GamePeg) {
        self.init(radius: gamePeg.radius * CircularExplosionPowerup.sizeProportionOfPeg, center: gamePeg.center)
    }

    func apply(gameBoard: GameBoard) -> Bool {
        for physicsBody in gameBoard.physicsBodies {
            guard let boardObject = physicsBody as? BoardObject else {
                continue
            }

            guard overlaps(with: boardObject) else {
                continue
            }

            physicsBody.collisionCount += 1

            if let gamePeg = physicsBody as? GamePeg {
                if gamePeg.willActivatePowerup {
                    gameBoard.powerups.append(CircularExplosionPowerup(from: gamePeg))
                    gamePeg.hasActivatedPowerup = true
                }
                gameBoard.removeGamePeg(gamePeg: gamePeg)
            }
        }

        return true
    }
}
