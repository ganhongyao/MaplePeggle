//
//  GameViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 13/2/22.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var isShowingDialog = false

    private(set) var controlsViewModel: GameControlsViewModel?

    private(set) var boardViewModel: GameBoardViewModel?

    private let board: Board

    init(board: Board) {
        self.board = board
        controlsViewModel = GameControlsViewModel(gameViewModel: self)
        boardViewModel = GameBoardViewModel(board: board, gameViewModel: self)
    }

    func endLevel() {
        boardViewModel?.deinitialiseDisplayLink()
    }

    func restartLevel() {
        boardViewModel?.restart()
    }
}
