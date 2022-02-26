//
//  BoardView.swift
//  PeggleClone
//
//  Created by Hong Yao on 27/1/22.
//

import SwiftUI

struct LevelDesignerBoardView: View {
    @ObservedObject var levelDesignerBoardViewModel: LevelDesignerBoardViewModel

    @State var lastScale: CGFloat = 1

    @State var lastAngle: Angle = .zero

    @State var isLetterboxed = false

    @State var screenHeight: CGFloat = .zero {
        didSet {
            levelDesignerBoardViewModel.unscrolledHeight = levelDesignerBoardViewModel.boardSize.height - screenHeight
        }
    }

    @State var horizontalBoardOffset: CGFloat = .zero

    @State var verticalBoardOffset: CGFloat = .zero

    private func letterbox(screenSize: CGSize) {
        let boardSize = levelDesignerBoardViewModel.boardBaseSize

        let boardAspectRatio = boardSize.aspectRatio
        let screenAspectRatio = screenSize.aspectRatio

        if screenAspectRatio > boardAspectRatio {
            scaleBoardToMatchScreenHeight(boardSize: boardSize,
                                          screenSize: screenSize)
        } else {
            scaleBoardToMatchScreenWidth(boardSize: boardSize,
                                         screenSize: screenSize)
        }
    }

    private func scaleBoardToMatchScreenHeight(boardSize: CGSize,
                                               screenSize: CGSize) {
        levelDesignerBoardViewModel.scaleFactor = screenSize.height / boardSize.height
        levelDesignerBoardViewModel.scaleBoard()
        let spareWidth = screenSize.width - levelDesignerBoardViewModel.boardBaseSize.width
        horizontalBoardOffset = spareWidth / 2
    }

    private func scaleBoardToMatchScreenWidth(boardSize: CGSize,
                                              screenSize: CGSize) {
        levelDesignerBoardViewModel.scaleFactor = screenSize.width / boardSize.width
        levelDesignerBoardViewModel.scaleBoard()
        let spareHeight = screenSize.height - levelDesignerBoardViewModel.boardBaseSize.height
        verticalBoardOffset = spareHeight / 2
    }

    /// Used for snapshots.
    var fullBoardView: some View {
        ZStack {
            Image(ViewConstants.coralBackgroundImage).resizable()

            ForEach(levelDesignerBoardViewModel.pegViewModels, id: \.pegId) { pegViewModel in
                PegView(pegViewModel: pegViewModel)
            }

            ForEach(levelDesignerBoardViewModel.blockViewModels, id: \.blockId) { blockViewModel in
                BlockView(blockViewModel: blockViewModel)
            }
        }
        .frame(width: levelDesignerBoardViewModel.boardSize.width,
               height: levelDesignerBoardViewModel.boardSize.height)
    }

    private func makePegView(pegViewModel: PegViewModel) -> some View {
        let exceededTop = pegViewModel.center.y - pegViewModel.radius -
            levelDesignerBoardViewModel.amountScrolledDownwards < 0
        let exceededBottom = pegViewModel.center.y + pegViewModel.radius -
            levelDesignerBoardViewModel.amountScrolledDownwards > screenHeight
        let canDisplayInFull = !exceededTop && !exceededBottom

        return PegView(pegViewModel: pegViewModel)
            .offset(y: -levelDesignerBoardViewModel.amountScrolledDownwards)
            .highPriorityGesture(TapGesture().onEnded {
                levelDesignerBoardViewModel.isInDeleteMode
                    ? pegViewModel.removePeg()
                    : pegViewModel.selectPeg()
            })
            .gesture(DragGesture().onChanged { value in
                pegViewModel.selectPeg()
                pegViewModel.movePeg(to: value.location)
            })
            .modifier(TranslucentViewModifier(shouldBeTranslucent: !canDisplayInFull))
            .clipped()
    }

    private func makeBlockView(blockViewModel: BlockViewModel) -> some View {
        let exceededTop = blockViewModel.minYCoordinate -
            levelDesignerBoardViewModel.amountScrolledDownwards < 0
        let exceededBottom = blockViewModel.maxYCoordinate -
            levelDesignerBoardViewModel.amountScrolledDownwards > screenHeight
        let canDisplayInFull = !exceededTop && !exceededBottom

        return BlockView(blockViewModel: blockViewModel,
                  yOffset: -levelDesignerBoardViewModel.amountScrolledDownwards)
            .highPriorityGesture(TapGesture().onEnded {
                levelDesignerBoardViewModel.isInDeleteMode
                    ? blockViewModel.removeBlock()
                    : blockViewModel.selectBlock()
            })
            .gesture(DragGesture().onChanged { value in
                blockViewModel.selectBlock()
                blockViewModel.moveBlock(to: value.location)
            })
            .modifier(TranslucentViewModifier(shouldBeTranslucent: !canDisplayInFull))
            .clipped()
    }

    private var mainBoardView: some View {
        ZStack {
            Image(ViewConstants.coralBackgroundImage).resizable()

            ForEach(levelDesignerBoardViewModel.pegViewModels, id: \.pegId) { pegViewModel in
                makePegView(pegViewModel: pegViewModel)
            }

            ForEach(levelDesignerBoardViewModel.blockViewModels, id: \.blockId) { blockViewModel in
                makeBlockView(blockViewModel: blockViewModel)
            }
        }
    }

    var body: some View {
        GeometryReader { geo in
            mainBoardView
                .gesture(DragGesture(minimumDistance: .zero, coordinateSpace: .local).onEnded { value in
                    if levelDesignerBoardViewModel.isInAddPegMode {
                        levelDesignerBoardViewModel.addPeg(center: value.location)
                    } else if levelDesignerBoardViewModel.isInAddBlockMode {
                        levelDesignerBoardViewModel.addBlock(center: value.location)
                    }
                })
                .gesture(MagnificationGesture().onChanged { value in
                    let scaleFactor = value / lastScale
                    lastScale = value
                    levelDesignerBoardViewModel.scaleBoardObject(factor: scaleFactor)
                }.onEnded { _ in
                    lastScale = 1.0
                }.simultaneously(with: RotationGesture().onChanged { angle in
                    let delta = angle - lastAngle
                    lastAngle = angle
                    levelDesignerBoardViewModel.rotateBoardObject(angle: delta.radians)
                }.onEnded { _ in
                    lastAngle = .zero
                }))
                .onChange(of: geo.size) { size in
                    screenHeight = size.height

                    guard levelDesignerBoardViewModel.isNewBoard else {
                        letterbox(screenSize: geo.size)
                        isLetterboxed = true
                        return
                    }

                    levelDesignerBoardViewModel.boardBaseSize = size
                    levelDesignerBoardViewModel.boardSize = size
                }
        }
        .offset(y: verticalBoardOffset)
        .frame(width: !isLetterboxed ? nil : levelDesignerBoardViewModel.boardBaseSize.width,
               height: !isLetterboxed ? nil : levelDesignerBoardViewModel.boardBaseSize.height)
        .alert(isPresented: $levelDesignerBoardViewModel.isShowingError, error: levelDesignerBoardViewModel.error) {}
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LevelDesignerBoardViewModel(boardId: nil, levelDesignerViewModel: LevelDesignerViewModel())
        LevelDesignerBoardView(levelDesignerBoardViewModel: viewModel)
    }
}
