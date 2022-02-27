//
//  LevelDesignerView.swift
//  PeggleClone
//
//  Created by Hong Yao on 18/1/22.
//

import SwiftUI

struct LevelDesignerView: View {
    @ObservedObject var levelDesignerViewModel: LevelDesignerViewModel

    private var controlsView: some View {
        levelDesignerViewModel.controlsViewModel.map({ ControlsView(snapshotCallback: snapshotCallback,
                                                                    controlsViewModel: $0) })
    }

    private var boardView: LevelDesignerBoardView? {
        levelDesignerViewModel.boardViewModel.map({ LevelDesignerBoardView(levelDesignerBoardViewModel: $0) })
    }

    private var fullBoardView: some View {
        levelDesignerViewModel.boardViewModel.map({ boardViewModel in
            ZStack {
                Image(ViewConstants.coralBackgroundImage).resizable()

                ForEach(boardViewModel.pegViewModels, id: \.pegId) { pegViewModel in
                    LevelSelectorPegView(pegViewModel: pegViewModel)
                }

                ForEach(boardViewModel.blockViewModels, id: \.blockId) { blockViewModel in
                    LevelDesignerBlockView(blockViewModel: blockViewModel)
                }
            }
            .frame(width: boardViewModel.boardSize.width, height: boardViewModel.boardSize.height)
        })
    }

    @ViewBuilder
    private var pegSelectorView: some View {
        if let boardViewModel = levelDesignerViewModel.boardViewModel,
           let pegSelectorViewModel = levelDesignerViewModel.pegSelectorViewModel {
            PegSelectorView(boardViewModel: boardViewModel, pegSelectorViewModel: pegSelectorViewModel)
        }
    }

    private func snapshotCallback() {
        guard let fullBoardView = boardView?.fullBoardView else {
            return
        }

        // Temporarily unselect any selected object so that editing circles do not appear in SS, will set it back later
        let selectedObjects = levelDesignerViewModel.unselectBoardObjects()

        let capturingRect = CGRect(origin: .zero, size: levelDesignerViewModel.boardSize)
        let snapshotImage = fullBoardView.snapshot(capturingRect: capturingRect)
        levelDesignerViewModel.setBoardSnapshot(snapshotImage: snapshotImage)

        levelDesignerViewModel.reselectBoardObjects(selectedObjects: selectedObjects)
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
            .navigationTitle(ViewConstants.levelDesignerNavTitle)
            .onAppear {
                AudioPlayer.sharedInstance.play(sound: .floralLife, withFadeDuration: ViewConstants.audioFadeDuration)
            }
            .onDisappear {
                AudioPlayer.sharedInstance.stop(sound: .floralLife, withFadeDuration: ViewConstants.audioFadeDuration)
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
