//
//  GameControlsViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 13/2/22.
//

import Foundation

class GameControlsViewModel: ObservableObject {
    private unowned var gameViewModel: GameViewModel

    init(gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
    }

    func restartLevel() {
        gameViewModel.boardViewModel?.restart()
    }
}
