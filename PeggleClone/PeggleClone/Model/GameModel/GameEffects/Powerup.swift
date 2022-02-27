//
//  Powerup.swift
//  PeggleClone
//
//  Created by Hong Yao on 23/2/22.
//

protocol Powerup: GameEffect {
    /// Returns whether the powerup was applied.
    func apply(gameBoard: GameBoard) -> Bool
}
