//
//  GameViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 13/2/22.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var currentGameState = GameState.inProgress {
        didSet {
            guard currentGameState == .won || currentGameState == .lost else {
                return
            }

            isShowingDialog = true
            AudioPlayer.sharedInstance.play(sound: currentGameState == .won ? .victory : .defeat)
        }
    }

    @Published var isShowingDialog = false

    @Published var chosenGameMaster: GameMaster? {
        didSet {
            guard chosenGameMaster != nil else {
                return
            }

            boardViewModel?.initialiseDisplayLink()
        }
    }

    private(set) var controlsViewModel: GameControlsViewModel?

    private(set) var boardViewModel: GameBoardViewModel?

    private let board: Board

    init(board: Board) {
        self.board = board
        controlsViewModel = GameControlsViewModel(gameViewModel: self)
        boardViewModel = GameBoardViewModel(board: board, gameViewModel: self)
    }

    func exitLevel() {
        boardViewModel?.deinitialiseDisplayLink()
    }

    func restartLevel() {
        currentGameState = .inProgress
        boardViewModel?.restart()
        boardViewModel?.deinitialiseDisplayLink()
    }
}
