//
//  GameBoardView.swift
//  PeggleClone
//
//  Created by Hong Yao on 4/2/22.
//

import SwiftUI

struct GameBoardView: View {
    @StateObject var gameBoardViewModel: GameBoardViewModel

    @State var isAiming = false

    var body: some View {
        // swiftlint:disable:next closure_body_length
        GeometryReader { geo in
            ZStack {
                Image(ViewConstants.coralBackgroundImage).resizable()

                GameCannonView(gameCannonViewModel: gameBoardViewModel.cannonViewModel, isAiming: $isAiming)
                    .modifier(TranslucentViewModifier(shouldBeTranslucent: gameBoardViewModel.hasBallWithinBoard))
                    .animation(.easeInOut(duration: ViewConstants.gameBoardCannonAnimationDuration),
                               value: isAiming || gameBoardViewModel.hasBallWithinBoard)

                gameBoardViewModel.gameBall.map({ ball in
                    GameBallView(gameBallViewModel: GameBallViewModel(gameBall: ball)) })

                ZStack {
                    ForEach(gameBoardViewModel.gamePegs, id: \.id) { gamePeg in
                        GamePegView(gamePegViewModel: GamePegViewModel(gamePeg: gamePeg))
                            .transition(.scale(scale: ViewConstants.gameBoardObjectScaleOnRemoval)
                                            .combined(with: .opacity))
                    }
                }.animation(.easeInOut(duration: ViewConstants.gameBoardObjectAnimationDuration),
                            value: gameBoardViewModel.gamePegs)

                ZStack {
                    ForEach(gameBoardViewModel.gameBlocks, id: \.id) { gameBlock in
                        GameBlockView(gameBlockViewModel: GameBlockViewModel(gameBlock: gameBlock))
                            .transition(.scale(scale: ViewConstants.gameBoardObjectScaleOnRemoval)
                                            .combined(with: .opacity))
                    }
                }.animation(.easeInOut(duration: ViewConstants.gameBoardObjectAnimationDuration),
                            value: gameBoardViewModel.gameBlocks)

                GameBucketView(gameBucketViewModel: gameBoardViewModel.bucketViewModel)
            }
            .onAppear {
                let spareHeight = geo.size.height - gameBoardViewModel.boardSize.height
                let halfSpareHeight = spareHeight / 2
                gameBoardViewModel.setCannonHeight(halfSpareHeight)
                gameBoardViewModel.setBucketHeight(halfSpareHeight)
            }
            .onDisappear(perform: gameBoardViewModel.deinitialiseDisplayLink)
            .gesture(DragGesture(minimumDistance: 0).onChanged { value in
                isAiming = true
                gameBoardViewModel.aimCannon(towards: value.location)
            }.onEnded { _ in
                isAiming = false

                if gameBoardViewModel.shouldLaunchBall {
                    gameBoardViewModel.launchBall()
                }
            })
        }
    }
}
