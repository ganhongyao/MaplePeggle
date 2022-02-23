//
//  SpookyBallEffect.swift
//  PeggleClone
//
//  Created by Hong Yao on 23/2/22.
//

class SpookyBallEffect: GameEffect {
    func apply(gameBoard: GameBoard) -> Bool {
        guard !gameBoard.hasBallWithinBoard else {
            return false
        }

        guard let gameBall = gameBoard.gameBall else {
            return false
        }

        gameBall.center.y = gameBall.radius

        return true
    }
}
