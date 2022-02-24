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
        gameViewModel.exitLevel()
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
        GeometryReader { geo in
            VStack {
                gameControlsView
                    .frame(height: geo.size.height * ViewConstants.gameControlsHeightRatio,
                           alignment: .top)

                gameBoardView
            }
            .overlay(
                GameMasterSelectorView(chosenGameMaster: $gameViewModel.chosenGameMaster)
            )
            .alert(gameViewModel.currentGameState == .won
                       ? ViewConstants.gameWonDialogTitle
                       : ViewConstants.gameLostDialogTitle,
                   isPresented: $gameViewModel.isShowingDialog, actions: {
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
}
