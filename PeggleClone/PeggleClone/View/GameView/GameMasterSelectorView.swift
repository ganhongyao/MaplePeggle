//
//  GameMasterSelectorView.swift
//  PeggleClone
//
//  Created by Hong Yao on 23/2/22.
//

import SwiftUI

struct GameMasterSelectorView: View {

    let availableGameMasters: [GameMaster]

    @Binding var chosenGameMaster: GameMaster?

    var body: some View {
        if chosenGameMaster == nil {
            VStack {
                Text(ViewConstants.gameMasterSelectorTitle)
                    .foregroundColor(.black)
                    .font(.title)
                    .bold()

                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(availableGameMasters, id: \.name) { gameMaster in
                            HStack {
                                getGameBackgroundImage(gameMaster: gameMaster)
                                    .resizable()
                                    .frame(width: ViewConstants.gameMasterImageSize,
                                           height: ViewConstants.gameMasterImageSize)
                                    .cornerRadius(ViewConstants.gameMasterImageCornerRadius)
                                    .overlay(getGameMasterImage(gameMaster: gameMaster))

                                VStack {
                                    Text(gameMaster.name)
                                        .foregroundColor(.black)
                                        .font(.title2)

                                    Spacer()

                                    Text(gameMaster.powerup.description)
                                        .font(.caption)
                                        .padding()
                                }
                                .frame(maxWidth: .infinity)
                            }.onTapGesture {
                                withAnimation {
                                    chosenGameMaster = gameMaster
                                }
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
            .transition(.slide.combined(with: .opacity))
        }
    }
}
