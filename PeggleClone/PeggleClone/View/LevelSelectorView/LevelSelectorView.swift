//
//  LevelSelectorView.swift
//  PeggleClone
//
//  Created by Hong Yao on 25/1/22.
//

import SwiftUI

struct LevelSelectorView: View {
    @StateObject var levelSelectorViewModel = LevelSelectorViewModel()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: ViewConstants.levelSelectorColumnSpacing),
                                count: ViewConstants.levelSelectorItemsPerRow)

    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())) {
                Label(ViewConstants.levelSelectorCreateButtonText,
                      systemImage: ViewConstants.levelSelectorCreateButtonImage)
            }.buttonStyle(.bordered)

            ScrollView {
                LazyVGrid(columns: columns, spacing: ViewConstants.levelSelectorRowSpacing) {
                    ForEach(levelSelectorViewModel.boards) { board in
                        let boardCardViewModel = BoardCardViewModel(
                            board: board,
                            levelSelectorViewModel: levelSelectorViewModel
                        )
                        BoardCardView(boardCardViewModel: boardCardViewModel)
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
