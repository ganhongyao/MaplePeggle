//
//  BucketRestoreEffect.swift
//  MaplePeggle
//
//  Created by Hong Yao on 27/2/22.
//

class BucketRestoreEffect: GameEffect {
    func apply(gameBoard: GameBoard) -> Bool {
        guard !gameBoard.hasBallWithinBoard else {
            return false
        }

        gameBoard.gameBucket.width = gameBoard.gameBucket.initialWidth
        return true
    }
}
