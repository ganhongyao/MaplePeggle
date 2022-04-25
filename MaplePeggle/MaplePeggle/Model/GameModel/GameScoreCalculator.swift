//
//  GameScoreCalculator.swift
//  MaplePeggle
//
//  Created by Hong Yao on 27/2/22.
//

import Foundation

struct GameScoreCalculator {
    private static let bluePegPoints = 10
    private static let greenPegPoints = 10
    private static let orangePegPoints = 100
    private static let purplePegPoints = 500

    private static let tier1Multiplier = 100
    private static let minPercentageOrangePegsClearedForTier1 = 100.0

    private static let tier2Multiplier = 10
    private static let minPercentageOrangePegsClearedForTier2 = 88.0

    private static let tier3Multiplier = 5
    private static let minPercentageOrangePegsClearedForTier3 = 72.0

    private static let tier4Multiplier = 3
    private static let minPercentageOrangePegsClearedForTier4 = 60.0

    private static let tier5Multiplier = 2
    private static let minPercentageOrangePegsClearedForTier5 = 40.0

    private static let tier6Multiplier = 1
    private static let minPercentageOrangePegsClearedForTier6 = 0.0

    private static var pegColorsScoreWhenHit: [Peg.Color: Int] {
        [
            .blue: bluePegPoints,
            .green: greenPegPoints,
            .orange: orangePegPoints,
            .purple: purplePegPoints
        ]
    }

    static func calculateScoreForHittingPeg(gameBoard: GameBoard, gamePeg: GamePeg) -> Int {
        let rawPegScore = GameScoreCalculator.pegColorsScoreWhenHit[gamePeg.color] ?? 0

        return rawPegScore * calculateMultiplier(gameBoard: gameBoard, gamePegJustLit: gamePeg)
    }

    private static func calculateMultiplier(gameBoard: GameBoard, gamePegJustLit: GamePeg) -> Int {
        let numInitialOrangePegs = gameBoard.pegs.filter { $0.color == .orange }.count
        let numUnhitOrangePegs = gameBoard.gamePegs.filter { $0.color == .orange && !$0.hasCollided }.count

        var numOrangePegsClearedBeforeCollision = numInitialOrangePegs - numUnhitOrangePegs

        if gamePegJustLit.color == .orange {
            numOrangePegsClearedBeforeCollision -= 1
        }

        let percentageOfOrangePegsCleared = Double(numOrangePegsClearedBeforeCollision) /
            Double(numInitialOrangePegs) * 100

        switch percentageOfOrangePegsCleared {
        case minPercentageOrangePegsClearedForTier6..<minPercentageOrangePegsClearedForTier5:
            return tier6Multiplier
        case minPercentageOrangePegsClearedForTier5..<minPercentageOrangePegsClearedForTier4:
            return tier5Multiplier
        case minPercentageOrangePegsClearedForTier4..<minPercentageOrangePegsClearedForTier3:
            return tier4Multiplier
        case minPercentageOrangePegsClearedForTier3..<minPercentageOrangePegsClearedForTier2:
            return tier3Multiplier
        case minPercentageOrangePegsClearedForTier2..<minPercentageOrangePegsClearedForTier1:
            return tier2Multiplier
        case minPercentageOrangePegsClearedForTier1...:
            return tier1Multiplier
        default:
            return tier6Multiplier
        }
    }
}
