//
//  BoardView.swift
//  PeggleClone
//
//  Created by Hong Yao on 27/1/22.
//

import SwiftUI

struct LevelDesignerBoardView: View {
    @ObservedObject var levelDesignerBoardViewModel: LevelDesignerBoardViewModel

    @State var scale: CGFloat = 1

    @State var lastScale: CGFloat = 1

    private var mainBoardView: some View {
        ZStack {
            Image(ViewConstants.coralBackgroundImage).resizable()

            ForEach(levelDesignerBoardViewModel.pegViewModels, id: \.pegId) { pegViewModel in
                PegView(pegViewModel: pegViewModel)
                    .onTapGesture {
                        levelDesignerBoardViewModel.isInDeleteMode
                            ? pegViewModel.removePeg()
                            : pegViewModel.selectPeg()
                    }
            }

            ForEach(levelDesignerBoardViewModel.blockViewModels, id: \.blockId) { blockViewModel in
                BlockView(blockViewModel: blockViewModel)
                    .highPriorityGesture(TapGesture().onEnded {
                        levelDesignerBoardViewModel.isInDeleteMode
                            ? blockViewModel.removeBlock()
                            : blockViewModel.selectBlock()
                    })
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
                    let delta = value / lastScale
                    lastScale = value
                    let scaleFactor = scale * delta
                    levelDesignerBoardViewModel.scaleBoardObject(factor: scaleFactor)
                }.onEnded { _ in
                    lastScale = 1.0
                })
                // If the board is new, let GeoReader propose a size and set the board's size to the proposed size.
                .onAppear {
                    if levelDesignerBoardViewModel.isNewBoard {
                        levelDesignerBoardViewModel.boardSize = geo.size
                    }
                }
                .onChange(of: geo.size) { _ in
                    if levelDesignerBoardViewModel.isNewBoard {
                        levelDesignerBoardViewModel.boardSize = geo.size
                    }
                }
        }
        // If the board is not new, set the frame to the board's native size as saved in storage.
        .frame(width: levelDesignerBoardViewModel.isNewBoard ? nil : levelDesignerBoardViewModel.boardSize.width,
               height: levelDesignerBoardViewModel.isNewBoard ? nil : levelDesignerBoardViewModel.boardSize.height)
        .alert(isPresented: $levelDesignerBoardViewModel.isShowingError, error: levelDesignerBoardViewModel.error) {}
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LevelDesignerBoardViewModel(boardId: nil, levelDesignerViewModel: LevelDesignerViewModel())
        LevelDesignerBoardView(levelDesignerBoardViewModel: viewModel)
    }
}
