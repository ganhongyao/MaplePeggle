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
