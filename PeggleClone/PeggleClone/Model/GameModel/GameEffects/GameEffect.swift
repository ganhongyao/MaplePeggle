//
//  GameEffect.swift
//  PeggleClone
//
//  Created by Hong Yao on 23/2/22.
//

protocol GameEffect: AnyObject {
    /// Returns whether the effect was applied.
    func apply(gameBoard: GameBoard) -> Bool
}
