//
//  PegSelectorView.swift
//  PeggleClone
//
//  Created by Hong Yao on 27/1/22.
//

import SwiftUI

struct PegSelectorView: View {
    @ObservedObject var boardViewModel: LevelDesignerBoardViewModel

    @ObservedObject var pegSelectorViewModel: PegSelectorViewModel

    var body: some View {
        HStack {
            ForEach(pegSelectorViewModel.pegColors, id: \.rawValue) { color in
                Button(action: {
                    pegSelectorViewModel.setSelectedPegColor(color: color)
                }, label: {
                    getPegImage(color: color)
                        .resizable()
                        .scaledToFit()
                        .modifier(TranslucentViewModifier(shouldBeTranslucent: pegSelectorViewModel.isInAddPegMode
                                                && color == pegSelectorViewModel.selectedPegColor)
                        )
                        .overlay(
                            Text(String(boardViewModel.getPegCount(color: color)))
                                .bold()
                                .foregroundColor(.black)
                        )
                })
            }

            Button(action: {
                pegSelectorViewModel.enterAddBlockMode()
            }, label: {
                Image("peg-blue-triangle") // FIXME: replace image
                    .resizable()
                    .scaledToFit()
                    .modifier(TranslucentViewModifier(shouldBeTranslucent: pegSelectorViewModel.isInAddBlockMode))
                    .overlay(
                        Text(String(boardViewModel.blockCount))
                            .bold()
                            .foregroundColor(.black)
                    )
            })

            Spacer()

            Button(action: {
                withAnimation {
                    let canScrollUp = boardViewModel.amountScrolledDownwards >= ViewConstants.levelDesignerScrollAmount
                    guard canScrollUp else {
                        return
                    }

                    boardViewModel.amountScrolledDownwards -= ViewConstants.levelDesignerScrollAmount
                }
            }, label: {
                Image(systemName: ViewConstants.pegSelectorScrollUpImage)
                    .resizable()
                    .scaledToFit()
            })

            Button(action: {
                withAnimation {
                    if boardViewModel.unscrolledHeight <= 0 {
                        boardViewModel.boardSize.height += ViewConstants.levelDesignerScrollAmount
                    }

                    boardViewModel.amountScrolledDownwards += ViewConstants.levelDesignerScrollAmount
                }
            }, label: {
                Image(systemName: ViewConstants.pegSelectorScrollDownImage)
                    .resizable()
                    .scaledToFit()
            })

            Spacer()

            Button(action: {
                pegSelectorViewModel.enterDeleteMode()
            }, label: {
                Image(ViewConstants.deleteImage)
                    .resizable()
                    .scaledToFit()
                    .modifier(TranslucentViewModifier(shouldBeTranslucent: pegSelectorViewModel.isInDeleteMode))
            })
        }
        .padding()
    }
}
