//
//  GameBoardView.swift
//  MaplePeggle
//
//  Created by Hong Yao on 4/2/22.
//

import SwiftUI
import PhysicsEngine

struct GameBoardView: View {
    @StateObject var gameBoardViewModel: GameBoardViewModel

    @State var screenHeight: CGFloat = .zero

    @State var isAiming = false

    @State var horizontalBoardOffset: CGFloat = .zero

    @State var verticalBoardOffset: CGFloat = .zero

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

        let screenHeightInUse = screenHeight - verticalBoardOffset * 2

        if boardHeight - ballYCoordinate < (1 - ViewConstants.gameBallPreferredPlacement) * screenHeightInUse {
            return -(boardHeight - screenHeightInUse)
        }

        return -ballYCoordinate + preferredBallPlacement
    }

    private func letterbox(screenSize: CGSize) {
        let boardGameplaySize = gameBoardViewModel.boardBaseSize
        let screenGameplaySize = CGSize(
            width: screenSize.width,
            height: (1 - ViewConstants.cannonHeightRatio - ViewConstants.bucketHeightRatio) * screenSize.height
        )

        let boardGameplayAspectRatio = boardGameplaySize.aspectRatio
        let screenGameplayAspectRatio = screenGameplaySize.aspectRatio

        if screenGameplayAspectRatio > boardGameplayAspectRatio {
            scaleBoardToMatchScreenHeight(boardGameplaySize: boardGameplaySize,
                                          screenGameplaySize: screenGameplaySize)
        } else {
            scaleBoardToMatchScreenWidth(boardGameplaySize: boardGameplaySize,
                                         screenGameplaySize: screenGameplaySize)
        }
    }

    private func scaleBoardToMatchScreenHeight(boardGameplaySize: CGSize,
                                               screenGameplaySize: CGSize) {
        gameBoardViewModel.scaleFactor = screenGameplaySize.height / boardGameplaySize.height
        gameBoardViewModel.scaleBoard()
        let spareWidth = screenGameplaySize.width - gameBoardViewModel.boardBaseSize.width
        horizontalBoardOffset = spareWidth / 2
    }

    private func scaleBoardToMatchScreenWidth(boardGameplaySize: CGSize,
                                              screenGameplaySize: CGSize) {
        gameBoardViewModel.scaleFactor = screenGameplaySize.width / boardGameplaySize.width
        gameBoardViewModel.scaleBoard()
        let spareHeight = screenGameplaySize.height - gameBoardViewModel.boardBaseSize.height
        verticalBoardOffset = spareHeight / 2
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                getGameBackgroundImage(gameMaster: gameBoardViewModel.chosenGameMaster)
                    .resizable()
                    .blur(radius: ViewConstants.backgroundBlurRadius)

                GameCannonView(gameCannonViewModel: gameBoardViewModel.cannonViewModel, isAiming: $isAiming)
                    .offset(y: offset)
                    .modifier(TranslucentViewModifier(shouldBeTranslucent: gameBoardViewModel.hasBallWithinBoard))
                    .animation(.easeInOut(duration: ViewConstants.gameBoardCannonAnimationDuration),
                               value: isAiming || gameBoardViewModel.hasBallWithinBoard)
                    .clipped()

                gameBoardViewModel.gameBall.map({ ball in
                    GameBallView(gameBallViewModel: GameBallViewModel(gameBall: ball))
                        .offset(y: offset)
                        .clipped()
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
                    .clipped()
            }
            .offset(x: horizontalBoardOffset, y: verticalBoardOffset)
            .frame(width: gameBoardViewModel.boardBaseSize.width,
                   height: gameBoardViewModel.boardBaseSize.height)
            .onAppear {
                let screenSize = geo.size

                screenHeight = screenSize.height

                letterbox(screenSize: screenSize)

                gameBoardViewModel.setCannonHeight(screenHeight * ViewConstants.cannonHeightRatio)
                gameBoardViewModel.setBucketHeight(screenHeight * ViewConstants.bucketHeightRatio)
            }
            .onDisappear(perform: gameBoardViewModel.deinitialiseDisplayLink)
            .gesture(DragGesture(minimumDistance: 0).onChanged { value in
                isAiming = true
                let aimedLocation = CGPoint(x: value.location.x - horizontalBoardOffset,
                                            y: value.location.y - verticalBoardOffset)
                gameBoardViewModel.aimCannon(towards: aimedLocation)
            }.onEnded { _ in
                isAiming = false

                if gameBoardViewModel.shouldLaunchBall {
                    gameBoardViewModel.launchBall()
                }
            })
        }
    }
}
