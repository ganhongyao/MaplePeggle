//
//  BoardView.swift
//  PeggleClone
//
//  Created by Hong Yao on 27/1/22.
//

import SwiftUI

struct LevelDesignerBoardView: View {
    @ObservedObject var levelDesignerBoardViewModel: LevelDesignerBoardViewModel

    private var mainBoardView: some View {
        ZStack {
            Image(ViewConstants.coralBackgroundImage).resizable()

            ForEach(levelDesignerBoardViewModel.pegs) { peg in
                PegView(pegViewModel: PegViewModel(peg: peg, levelDesignerBoardViewModel: levelDesignerBoardViewModel))
                    .onTapGesture {
                        if levelDesignerBoardViewModel.isInDeleteMode {
                            levelDesignerBoardViewModel.removePeg(peg)
                        }
                    }
                    .onLongPressGesture {
                        levelDesignerBoardViewModel.removePeg(peg)
                    }
            }
        }
    }

    var body: some View {
        GeometryReader { geo in
            mainBoardView
                .gesture(DragGesture(minimumDistance: .zero, coordinateSpace: .local).onEnded { value in
                    if !levelDesignerBoardViewModel.isInDeleteMode {
                        levelDesignerBoardViewModel.addPeg(center: value.location)
                    }
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
