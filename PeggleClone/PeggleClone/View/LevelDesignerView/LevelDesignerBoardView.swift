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

    @State var lastPositionForCurrentDrag: CGPoint?

    @State var isLetterboxed = false

    @State var screenHeight: CGFloat = .zero {
        didSet {
            levelDesignerBoardViewModel.unscrolledHeight = levelDesignerBoardViewModel.boardSize.height - screenHeight
        }
    }

    @State var horizontalBoardOffset: CGFloat = .zero

    @State var verticalBoardOffset: CGFloat = .zero

    @State var selectedRectStart: CGPoint?

    @State var selectedRectEnd: CGPoint?

    private var selectedRect: CGRect? {
        guard let rectStart = selectedRectStart,
              let rectEnd = selectedRectEnd else {
                  return nil
              }

        let origin = CGPoint(x: min(rectStart.x, rectEnd.x),
                             y: min(rectStart.y, rectEnd.y))

        let size = CGSize(width: abs(rectStart.x - rectEnd.x),
                          height: abs(rectStart.y - rectEnd.y))

        return CGRect(origin: origin, size: size)
    }

    @ViewBuilder
    private var selectedRectShape: some View {
        if let selectedRect = selectedRect {
            Path(selectedRect)
                .stroke(ViewConstants.levelDesignerSelectionColor,
                        style: StrokeStyle(lineWidth: ViewConstants.levelDesignerBoardSelectionStrokeWidth,
                                           dash: [ViewConstants.levelDesignerBoardSelectionStrokeDash]))
        }
    }

    private func letterbox(screenSize: CGSize) {
        isLetterboxed = true
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
                    : pegViewModel.toggleSelected()
            })
            .gesture(DragGesture().onChanged { value in
                if !levelDesignerBoardViewModel.isInMultiselectMode {
                    levelDesignerBoardViewModel.unselectAllObjects()
                }
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
                    : blockViewModel.toggleSelected()
            })
            .gesture(DragGesture().onChanged { value in
                levelDesignerBoardViewModel.unselectAllObjects()
                blockViewModel.selectBlock()
                blockViewModel.moveBlock(to: value.location)
            })
            .modifier(TranslucentViewModifier(shouldBeTranslucent: !canDisplayInFull))
            .clipped()
    }

    private var mainBoardView: some View {
        ZStack {
            Image(ViewConstants.coralBackgroundImage).resizable()

            selectedRectShape

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
            ZStack {
                mainBoardView
                    .gesture(
                        DragGesture(minimumDistance: .zero, coordinateSpace: .local)
                            .onChanged { value in
                                guard levelDesignerBoardViewModel.isInMultiselectMode else {
                                    return
                                }

                                guard levelDesignerBoardViewModel.hasSelectedObjects else {
                                    selectedRectStart = value.startLocation
                                    selectedRectEnd = value.location
                                    return
                                }

                                let currentLocation = value.location

                                guard let lastPositionForCurrentDrag = lastPositionForCurrentDrag else {
                                    lastPositionForCurrentDrag = currentLocation
                                    return
                                }

                                let movementOffset = CGVector(from: currentLocation)
                                    .subtract(CGVector(from: lastPositionForCurrentDrag))

                                self.lastPositionForCurrentDrag = currentLocation

                                levelDesignerBoardViewModel.moveBoardObjects(offset: movementOffset)
                            }.onEnded { value in
                                if levelDesignerBoardViewModel.isInAddPegMode {
                                    levelDesignerBoardViewModel.addPeg(center: value.location)
                                } else if levelDesignerBoardViewModel.isInAddBlockMode {
                                    levelDesignerBoardViewModel.addBlock(center: value.location)
                                }

                                if let selectedRect = selectedRect {
                                    levelDesignerBoardViewModel.selectObjects(inRectangle: selectedRect)
                                    selectedRectStart = nil
                                    selectedRectEnd = nil
                                }

                                lastPositionForCurrentDrag = nil
                    })
                    .gesture(MagnificationGesture().onChanged { value in
                        let scaleFactor = value / lastScale
                        lastScale = value
                        levelDesignerBoardViewModel.scaleBoardObjects(factor: scaleFactor)
                    }.onEnded { _ in
                        lastScale = 1.0
                    }.simultaneously(with: RotationGesture().onChanged { angle in
                        let delta = angle - lastAngle
                        lastAngle = angle
                        levelDesignerBoardViewModel.rotateBoardObjects(angle: delta.radians)
                    }.onEnded { _ in
                        lastAngle = .zero
                    }))
                    .onChange(of: geo.size) { size in
                        if levelDesignerBoardViewModel.isNewBoard {
                            levelDesignerBoardViewModel.boardBaseSize = size
                            levelDesignerBoardViewModel.boardSize = size
                        }

                        screenHeight = size.height

                        guard !levelDesignerBoardViewModel.isNewBoard else {
                            return
                        }

                        letterbox(screenSize: geo.size)
                    }
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
