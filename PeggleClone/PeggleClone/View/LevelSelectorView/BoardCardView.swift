//
//  BoardCardView.swift
//  PeggleClone
//
//  Created by Hong Yao on 28/1/22.
//

import SwiftUI

struct BoardCardView: View {
    @ObservedObject var boardCardViewModel: BoardCardViewModel

    var body: some View {
        let levelDesignerViewModel = LevelDesignerViewModel(boardId: boardCardViewModel.boardId)
        let levelDesignerView = LevelDesignerView(levelDesignerViewModel: levelDesignerViewModel)

        // swiftlint:disable:next closure_body_length
        VStack {
            NavigationLink(destination: levelDesignerView) {
                makeSnapshotImage(snapshotImageData: boardCardViewModel.snapshotImageData)
                    .resizable()
                    .scaledToFit()
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(boardCardViewModel.name)
                        .font(.title2)
                        .bold()
                        .lineLimit(ViewConstants.boardCardLineLimit)

                    Text(boardCardViewModel.caption)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(ViewConstants.boardCardLineLimit)
                        .minimumScaleFactor(ViewConstants.boardCardTextScaleFactor)
                }

                Spacer()

                NavigationLink(destination: levelDesignerView) {
                    Image(systemName: ViewConstants.boardCardEditButtonImage)
                        .font(.system(size: ViewConstants.boardCardIconButtonSize))
                }

                Button(action: boardCardViewModel.deleteBoard) {
                    Image(systemName: ViewConstants.boardCardDeleteButtonImage)
                        .font(.system(size: ViewConstants.boardCardIconButtonSize))
                }
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(Color.yellow)
        .cornerRadius(ViewConstants.boardCardCornerRadius)
        .shadow(radius: ViewConstants.boardCardShadowRadius)
        .alert(isPresented: $boardCardViewModel.isShowingError,
               error: boardCardViewModel.error, actions: { _ in }) { error in
            Text(error.failureReason ?? "")
        }
    }
}
