//
//  BucketExpansionPowerup.swift
//  PeggleClone
//
//  Created by Hong Yao on 27/2/22.
//

import Foundation

class BucketExpansionPowerup: Powerup {
    private static let bucketWidthScaleFactor = 1.5

    func apply(gameBoard: GameBoard) -> Bool {
        let newBucketWidth = min(gameBoard.gameBucket.width * BucketExpansionPowerup.bucketWidthScaleFactor,
                                 gameBoard.size.width)

        gameBoard.gameBucket.width = newBucketWidth

        let hasRestoreEffect = gameBoard.gameEffects.contains(where: { $0 is BucketRestoreEffect })

        guard !hasRestoreEffect else {
            return true
        }

        gameBoard.gameEffects.append(BucketRestoreEffect())
        return true
    }
}
