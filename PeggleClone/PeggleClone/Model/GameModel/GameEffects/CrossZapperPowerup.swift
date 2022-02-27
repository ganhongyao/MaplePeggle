//
//  CrossZapperPowerup.swift
//  PeggleClone
//
//  Created by Hong Yao on 27/2/22.
//

import CoreGraphics

class CrossZapperPowerup: Powerup {
    private static let thicknessProportionOfPegDiameter = 1.0

    var center: CGPoint

    var thickness: CGFloat

    init(center: CGPoint, thickness: CGFloat) {
        self.center = center
        self.thickness = thickness
    }

    convenience init(from gamePeg: GamePeg) {
        self.init(center: gamePeg.center,
                  thickness: gamePeg.diameter * CrossZapperPowerup.thicknessProportionOfPegDiameter)
    }

    func apply(gameBoard: GameBoard) -> Bool {
        let verticalZapper = GenericPolygon(from: CGRect(x: center.x - thickness / 2, y: 0,
                                                         width: thickness, height: gameBoard.size.height))

        let horizontalZapper = GenericPolygon(from: CGRect(x: 0, y: center.y - thickness / 2,
                                                           width: gameBoard.size.width, height: thickness))

        for physicsBody in gameBoard.physicsBodies {
            guard let boardObject = physicsBody as? BoardObject else {
                continue
            }

            guard verticalZapper.overlaps(with: boardObject) || horizontalZapper.overlaps(with: boardObject) else {
                continue
            }

            physicsBody.collisionCount += 1

            guard let collidedGamePeg = physicsBody as? GamePeg else {
                continue
            }

            gameBoard.handleScoringForLitPeg(litPeg: collidedGamePeg)
        }

        return true
    }
}
