//
//  GameControlsView.swift
//  PeggleClone
//
//  Created by Hong Yao on 13/2/22.
//

import SwiftUI

struct GameControlsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

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

            Button(action: controlsViewModel.restartLevel) {
                Label(ViewConstants.gameRestartButtonText, systemImage: ViewConstants.gameRestartButtonImage)
            }
        }
        .padding()
        .buttonStyle(.bordered)
    }
}
