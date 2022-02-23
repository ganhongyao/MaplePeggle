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
                        ForEach(GameMaster.availableGameMasters, id: \.name) { gameMaster in
                            HStack {
                                Image(ViewConstants.coralBackgroundImage)
                                    .resizable()
                                    .frame(width: ViewConstants.gameMasterImageSize,
                                           height: ViewConstants.gameMasterImageSize)
                                    .cornerRadius(ViewConstants.gameMasterImageCornerRadius)

                                VStack {
                                    Text(gameMaster.name)
                                        .foregroundColor(.black)
                                        .font(.title2)

                                    Spacer()

                                    Text(gameMaster.description)
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
