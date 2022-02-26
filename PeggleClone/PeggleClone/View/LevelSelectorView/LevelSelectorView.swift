//
//  LevelSelectorView.swift
//  PeggleClone
//
//  Created by Hong Yao on 25/1/22.
//

import SwiftUI

struct LevelSelectorView: View {
    @StateObject var levelSelectorViewModel = LevelSelectorViewModel()

    private var columns: [[Board]] {
        Array(0..<ViewConstants.levelSelectorNumColumns).map { colIdx in
            let boardIndicesForColumn = stride(from: colIdx,
                                               to: levelSelectorViewModel.boards.count,
                                               by: ViewConstants.levelSelectorNumColumns)

            return boardIndicesForColumn.map { boardIdx in
                levelSelectorViewModel.boards[boardIdx]
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())) {
                Label(ViewConstants.levelSelectorCreateButtonText,
                      systemImage: ViewConstants.levelSelectorCreateButtonImage)
            }.buttonStyle(.bordered)

            ScrollView {
                HStack(alignment: .top, spacing: ViewConstants.levelSelectorColumnSpacing) {
                    ForEach(columns.indices) { colIdx in
                        let boardsInColumn = columns[colIdx]
                        VStack(spacing: ViewConstants.levelSelectorRowSpacing) {
                            ForEach(boardsInColumn) { board in
                                let boardCardViewModel = BoardCardViewModel(
                                    board: board,
                                    levelSelectorViewModel: levelSelectorViewModel
                                )
                                BoardCardView(boardCardViewModel: boardCardViewModel)
                            }
                        }
                    }
                }
            }.padding(.top)
        }
        .padding(.horizontal)
        .navigationTitle(ViewConstants.levelSelectorNavTitle)
        .onAppear {
            levelSelectorViewModel.fetchAllBoards()
        }
        .alert(isPresented: $levelSelectorViewModel.isShowingError, error: levelSelectorViewModel.error) {}
    }
}

struct LevelLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectorView()
    }
}
