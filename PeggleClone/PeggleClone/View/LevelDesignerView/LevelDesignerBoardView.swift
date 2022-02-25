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

    @State var screenHeight: CGFloat = .zero {
        didSet {
            levelDesignerBoardViewModel.unscrolledHeight = levelDesignerBoardViewModel.boardSize.height - screenHeight
        }
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

    private var mainBoardView: some View {
        ZStack {
            Image(ViewConstants.coralBackgroundImage).resizable()

            ForEach(levelDesignerBoardViewModel.pegViewModels, id: \.pegId) { pegViewModel in
                let exceededTop = pegViewModel.center.y - pegViewModel.radius -
                    levelDesignerBoardViewModel.amountScrolledDownwards < 0
                let exceededBottom = pegViewModel.center.y + pegViewModel.radius -
                    levelDesignerBoardViewModel.amountScrolledDownwards > screenHeight
                let shouldBeDisplayed = !exceededTop && !exceededBottom

                if shouldBeDisplayed {
                    PegView(pegViewModel: pegViewModel)
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

                }
            }

            ForEach(levelDesignerBoardViewModel.blockViewModels, id: \.blockId) { blockViewModel in
                let exceededTop = blockViewModel.minYCoordinate -
                    levelDesignerBoardViewModel.amountScrolledDownwards < 0
                let exceededBottom = blockViewModel.maxYCoordinate -
                    levelDesignerBoardViewModel.amountScrolledDownwards > screenHeight
                let shouldBeDisplayed = !exceededTop && !exceededBottom

                if shouldBeDisplayed {
                    BlockView(blockViewModel: blockViewModel,
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
                }
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
                // If the board is new, let GeoReader propose a size and set the board's size to the proposed size.
                .onChange(of: geo.size) { _ in
                    if levelDesignerBoardViewModel.isNewBoard {
                        levelDesignerBoardViewModel.boardSize = geo.size
                    }
                    screenHeight = geo.size.height
                }
        }
        // If the board is not new, set the frame to the board's native size as saved in storage.
        .frame(width: levelDesignerBoardViewModel.isNewBoard ? nil : levelDesignerBoardViewModel.boardSize.width)
        .alert(isPresented: $levelDesignerBoardViewModel.isShowingError, error: levelDesignerBoardViewModel.error) {}
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LevelDesignerBoardViewModel(boardId: nil, levelDesignerViewModel: LevelDesignerViewModel())
        LevelDesignerBoardView(levelDesignerBoardViewModel: viewModel)
    }
}
