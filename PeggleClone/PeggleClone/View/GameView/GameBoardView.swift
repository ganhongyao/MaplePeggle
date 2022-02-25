//
//  GameBoardView.swift
//  PeggleClone
//
//  Created by Hong Yao on 4/2/22.
//

import SwiftUI
import PhysicsEngine

struct GameBoardView: View {
    @StateObject var gameBoardViewModel: GameBoardViewModel

    @State var screenHeight: CGFloat = .zero

    @State var isAiming = false

    private var boardHeight: CGFloat {
        gameBoardViewModel.boardSize.height
    }

    private var ballYCoordinate: CGFloat? {
        gameBoardViewModel.gameBall?.center.y
    }

    private var offset: CGFloat {
        let preferredBallPlacement = ViewConstants.gameBallPreferredPlacement * screenHeight

        guard let ballYCoordinate = ballYCoordinate,
              ballYCoordinate > preferredBallPlacement else {
            return 0
        }

        if boardHeight - ballYCoordinate < (1 - ViewConstants.gameBallPreferredPlacement) * screenHeight {
            return -(boardHeight - screenHeight)
        }

        return -ballYCoordinate + preferredBallPlacement
    }

    var body: some View {
        // swiftlint:disable:next closure_body_length
        GeometryReader { geo in
            ZStack {
                Image(ViewConstants.coralBackgroundImage).resizable()

                GameCannonView(gameCannonViewModel: gameBoardViewModel.cannonViewModel, isAiming: $isAiming)
                    .offset(y: offset)
                    .modifier(TranslucentViewModifier(shouldBeTranslucent: gameBoardViewModel.hasBallWithinBoard))
                    .animation(.easeInOut(duration: ViewConstants.gameBoardCannonAnimationDuration),
                               value: isAiming || gameBoardViewModel.hasBallWithinBoard)
                    .clipped()

                gameBoardViewModel.gameBall.map({ ball in
                    GameBallView(gameBallViewModel: GameBallViewModel(gameBall: ball))
                        .offset(y: offset)
                })

                ZStack {
                    ForEach(gameBoardViewModel.gamePegs, id: \.id) { gamePeg in
                        GamePegView(gamePegViewModel: GamePegViewModel(gamePeg: gamePeg))
                            .offset(y: offset)
                            .transition(.scaleAndOpacityOnRemove(scaleFactor:
                                                                    ViewConstants.gameBoardObjectScaleOnRemoval))
                            .clipped()
                    }
                }.animation(.easeInOut(duration: ViewConstants.gameBoardObjectAnimationDuration),
                            value: gameBoardViewModel.gamePegs)

                ZStack {
                    ForEach(gameBoardViewModel.gameBlocks, id: \.id) { gameBlock in
                        GameBlockView(gameBlockViewModel: GameBlockViewModel(gameBlock: gameBlock), yOffset: offset)
                            .transition(.scaleAndOpacityOnRemove(scaleFactor:
                                                                    ViewConstants.gameBoardObjectScaleOnRemoval))
                            .clipped()
                    }
                }.animation(.easeInOut(duration: ViewConstants.gameBoardObjectAnimationDuration),
                            value: gameBoardViewModel.gameBlocks)

                GameBucketView(gameBucketViewModel: gameBoardViewModel.bucketViewModel)
                    .offset(y: offset)
            }
            .onAppear {
                screenHeight = geo.size.height
                gameBoardViewModel.setCannonHeight(screenHeight * ViewConstants.cannonHeightRatio)
                gameBoardViewModel.setBucketHeight(screenHeight * ViewConstants.bucketHeightRatio)
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
