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

            ForEach(boardViewModel.pegColors, id: \.rawValue) { color in
                getPegImage(color: color)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        Text(String(boardViewModel.numPegsRemaining(color: color)))
                            .bold()
                            .foregroundColor(.black)
                    )
            }

            Spacer()

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

            VStack {
                Text("Score")
                Text("12301")
            }

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
