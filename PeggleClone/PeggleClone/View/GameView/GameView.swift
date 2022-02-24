//
//  GameView.swift
//  PeggleClone
//
//  Created by Hong Yao on 4/2/22.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject var gameViewModel: GameViewModel

    private func returnToLevelDesigner() {
        gameViewModel.endLevel()
        dismiss()
    }

    @ViewBuilder
    private var gameControlsView: some View {
        if let boardViewModel = gameViewModel.boardViewModel,
           let controlsViewModel = gameViewModel.controlsViewModel {
            GameControlsView(boardViewModel: boardViewModel, controlsViewModel: controlsViewModel)
        }
    }

    private var gameBoardView: some View {
        gameViewModel.boardViewModel.map({ GameBoardView(gameBoardViewModel: $0) })
    }

    var body: some View {
        VStack {
            gameControlsView

            gameBoardView
        }
        .overlay(
            GameMasterSelectorView(chosenGameMaster: $gameViewModel.chosenGameMaster)

        )
        .alert(ViewConstants.gameCompletedDialogTitle, isPresented: $gameViewModel.isShowingDialog, actions: {
            Button(ViewConstants.gameRestartDialogButtonText) {
                gameViewModel.restartLevel()
            }

            Button(ViewConstants.gameReturnButtonText) {
                returnToLevelDesigner()
            }
        })
        .navigationBarHidden(true)
    }
}
