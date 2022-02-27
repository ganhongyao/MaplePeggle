//
//  GameScoreCalculator.swift
//  PeggleClone
//
//  Created by Hong Yao on 27/2/22.
//

import Foundation

struct GameScoreCalculator {
    private static var pegColorsScoreWhenHit: [Peg.Color: Int] {
        [
            .blue: 10,
            .green: 10,
            .orange: 100,
            .purple: 500
        ]
    }

    static func calculateScoreForHittingPeg(gameBoard: GameBoard, gamePeg: GamePeg) -> Int {
        let rawPegScore = GameScoreCalculator.pegColorsScoreWhenHit[gamePeg.color] ?? 0

        return rawPegScore * calculateMultiplier(gameBoard: gameBoard)
    }

    private static func calculateMultiplier(gameBoard: GameBoard) -> Int {
        let numInitialOrangePegs = gameBoard.pegs.filter { $0.color == .orange }.count
        let numUnhitOrangePegs = gameBoard.gamePegs.filter { $0.color == .orange && !$0.hasCollided }.count
        let numClearedOrangePegs = numInitialOrangePegs - numUnhitOrangePegs
        let percentageOfOrangePegsCleared = Double(numClearedOrangePegs) / Double(numInitialOrangePegs) * 100

        switch percentageOfOrangePegsCleared {
        case 0..<40:
            return 1
        case 40..<60:
            return 2
        case 60..<72:
            return 3
        case 72..<88:
            return 5
        case 88..<100:
            return 10
        case 100:
            return 100
        default:
            return 1
        }
    }
}
