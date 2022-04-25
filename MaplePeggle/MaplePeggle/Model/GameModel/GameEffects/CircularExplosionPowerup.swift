//
//  CircularExplosionPowerup.swift
//  MaplePeggle
//
//  Created by Hong Yao on 23/2/22.
//

import PhysicsEngine
import CoreGraphics

class CircularExplosionPowerup: Circular, Powerup {
    private static let radiusProportionOfPeg = 3.0

    var radius: CGFloat

    var center: CGPoint

    init(blastRadius: CGFloat, blastCenter: CGPoint) {
        radius = blastRadius
        center = blastCenter
    }

    convenience init(from gamePeg: GamePeg) {
        gamePeg.radius *= CircularExplosionPowerup.radiusProportionOfPeg
        self.init(blastRadius: gamePeg.radius, blastCenter: gamePeg.center)
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

            guard let collidedGamePeg = physicsBody as? GamePeg else {
                continue
            }

            gameBoard.pegsToBeRemovedQueue.append(collidedGamePeg)
            gameBoard.handleScoringForLitPeg(litPeg: collidedGamePeg)

            guard collidedGamePeg.willActivatePowerup else {
                continue
            }

            collidedGamePeg.hasActivatedPowerup = true
            gameBoard.gameEffects.append(CircularExplosionPowerup(from: collidedGamePeg))
        }

        return true
    }
}
