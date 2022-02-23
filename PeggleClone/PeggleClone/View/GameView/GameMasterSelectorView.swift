//
//  GameMasterSelectorView.swift
//  PeggleClone
//
//  Created by Hong Yao on 23/2/22.
//

import SwiftUI

struct GameMasterSelectorView: View {

    @Binding var chosenGameMaster: GameMaster?

    var body: some View {
        if chosenGameMaster == nil {
            VStack {
                Text(ViewConstants.gameMasterSelectorTitle)
                    .foregroundColor(.black)
                    .font(.title)
                    .bold()

                ScrollView {
                    VStack {
                        ForEach(GameMaster.allCases, id: \.self) { gameMaster in
                            HStack {
                                Image(ViewConstants.coralBackgroundImage)
                                    .resizable()
                                    .frame(width: ViewConstants.gameMasterImageSize,
                                           height: ViewConstants.gameMasterImageSize)
                                    .cornerRadius(ViewConstants.gameMasterImageCornerRadius)

                                VStack {
                                    Text(gameMaster.rawValue)
                                        .foregroundColor(.black)
                                        .font(.title2)

                                    Spacer()

                                    Text("""
                                         Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do \
                                         eiusmod tempor incididunt ut labore et dolore magna aliqua. Lectus \
                                         vestibulum mattis ullamcorper velit sed ullamcorper morbi.
                                         """)
                                        .font(.caption)
                                        .padding()
                                }
                            }.onTapGesture {
                                chosenGameMaster = gameMaster
                            }
                            .padding()
                        }
                    }
                }
            }
            .padding()
            .frame(width: ViewConstants.gameMasterDialogSize, height: ViewConstants.gameMasterDialogSize)
            .background(.yellow)
            .foregroundColor(.black)
            .cornerRadius(ViewConstants.gameMasterDialogCornerRadius)
            .shadow(radius: ViewConstants.gameMasterDialogShadowRadius)
        }
    }
}
