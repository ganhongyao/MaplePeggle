//
//  LevelDesignerView.swift
//  PeggleClone
//
//  Created by Hong Yao on 18/1/22.
//

import SwiftUI

struct LevelDesignerView: View {
    @ObservedObject var levelDesignerViewModel: LevelDesignerViewModel

    private var boardView: some View {
        levelDesignerViewModel.boardViewModel.map({ LevelDesignerBoardView(levelDesignerBoardViewModel: $0) })
    }

    private var controlsView: some View {
        levelDesignerViewModel.controlsViewModel.map({ ControlsView(snapshotCallback: snapshotCallback,
                                                                    controlsViewModel: $0) })
    }

    @ViewBuilder
    private var pegSelectorView: some View {
        if let boardViewModel = levelDesignerViewModel.boardViewModel,
           let pegSelectorViewModel = levelDesignerViewModel.pegSelectorViewModel {
            PegSelectorView(boardViewModel: boardViewModel, pegSelectorViewModel: pegSelectorViewModel)
        }
    }

    private func snapshotCallback() {
        // Temporarily unselect any selected object so that editing circles do not appear in SS, will set it back later
        let selectedObject = levelDesignerViewModel.unselectBoardObject()

        let capturingRect = CGRect(origin: .zero, size: levelDesignerViewModel.boardSize)
        let snapshotImage = boardView.snapshot(capturingRect: capturingRect)
        levelDesignerViewModel.setBoardSnapshot(snapshotImage: snapshotImage)

        levelDesignerViewModel.reselectBoardObject(selectedObject: selectedObject)
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                controlsView

                boardView

                Spacer()

                pegSelectorView
                    .frame(height: geo.size.height * ViewConstants.levelDesignerPegSelectorHeightRatio,
                           alignment: .bottom)
            }
        }
        .ignoresSafeArea(.keyboard) // Prevents board view from being compressed vertically when keyboard is displayed
        .alert(isPresented: $levelDesignerViewModel.isShowingError, error: levelDesignerViewModel.error) {}
    }
}

struct LevelDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())
    }
}
