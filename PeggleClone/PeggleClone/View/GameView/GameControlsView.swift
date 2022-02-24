//
//  GameControlsView.swift
//  PeggleClone
//
//  Created by Hong Yao on 13/2/22.
//

import SwiftUI

struct GameControlsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var boardViewModel: GameBoardViewModel

    @ObservedObject var controlsViewModel: GameControlsViewModel

    private func returnToLevelDesigner() {
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        HStack {
            Button(action: returnToLevelDesigner) {
                Label(ViewConstants.gameQuitButtonText, systemImage: ViewConstants.gameQuitButtonImage)
            }

            Spacer()

            getPegImage(color: .orange)
                .resizable()
                .scaledToFit()
                .overlay(
                    Text(String(boardViewModel.numPegsRemaining(color: .orange)))
                        .bold()
                )

            Image(ViewConstants.ballImage)
                .resizable()
                .scaledToFit()
                .overlay(
                    Text(String(boardViewModel.numBallsRemaining))
                        .bold()
                        .foregroundColor(boardViewModel.numBallsRemaining <=
                                         ViewConstants.gameBallThresholdForWarning ? .red : .black)
                )

            Spacer()

            Button {
                withAnimation {
                    controlsViewModel.restartLevel()
                }
            } label: {
                Label(ViewConstants.gameRestartButtonText, systemImage: ViewConstants.gameRestartButtonImage)
            }
        }
        .padding(.horizontal)
        .buttonStyle(.bordered)
    }
}
