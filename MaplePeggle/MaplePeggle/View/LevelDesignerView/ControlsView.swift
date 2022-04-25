//
//  LevelDesignerControlsView.swift
//  MaplePeggle
//
//  Created by Hong Yao on 19/1/22.
//

import SwiftUI

struct ControlsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let snapshotCallback: () -> Void

    @State var controlsViewModel: ControlsViewModel

    private func returnToPreviousNavigationView() {
        presentationMode.wrappedValue.dismiss()
    }

    private var gameView: some View {
        controlsViewModel.board.map({ GameView(gameViewModel: GameViewModel(board: $0)) })
    }

    var body: some View {
        HStack {
            NavigationLink(destination: gameView) {
                Text(ViewConstants.controlsStartButtonText)
            }

            Button(action: returnToPreviousNavigationView) {
                Text(ViewConstants.controlsLoadButtonText)
            }

            Button {
                controlsViewModel.trimAddedButUnusedHeightFromBoard()
                snapshotCallback()
                controlsViewModel.save()
                controlsViewModel.addBackTrimmedHeightForEditing()
            } label: {
                Text(ViewConstants.controlsSaveButtonText)
            }

            TextField(ViewConstants.controlsTextFieldLabel, text: $controlsViewModel.levelName)

            Button(action: controlsViewModel.reset) {
                Text(ViewConstants.controlsResetButtonText)
            }
        }
        .padding()
    }
}

struct LevelDesignerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView(snapshotCallback: {},
                     controlsViewModel: ControlsViewModel(levelDesignerViewModel: LevelDesignerViewModel()))
    }
}
