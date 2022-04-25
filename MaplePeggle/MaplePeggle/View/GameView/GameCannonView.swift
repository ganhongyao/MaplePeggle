//
//  GameCannonView.swift
//  MaplePeggle
//
//  Created by Hong Yao on 8/2/22.
//

import SwiftUI

struct GameCannonView: View {
    @ObservedObject var gameCannonViewModel: GameCannonViewModel

    @Binding var isAiming: Bool

    var body: some View {
        ZStack {
            Image(ViewConstants.cannonImage)
                .resizable()
                .frame(width: gameCannonViewModel.cannonHeight, height: gameCannonViewModel.cannonHeight)
                .rotationEffect(.radians(gameCannonViewModel.rotationAngle))
                .position(gameCannonViewModel.cannonPosition)

            if isAiming {
                Image(systemName: ViewConstants.cannonAimCancelImage)
                    .resizable()
                    .frame(width: gameCannonViewModel.cannonHeight, height: gameCannonViewModel.cannonHeight)
                    .position(gameCannonViewModel.cannonPosition)
                    .opacity(ViewConstants.cannonAimCancelOpacity)
            }
        }.padding(ViewConstants.cannonPadding)
    }
}
