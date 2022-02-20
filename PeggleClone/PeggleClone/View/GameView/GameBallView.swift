//
//  GameBallView.swift
//  PeggleClone
//
//  Created by Hong Yao on 4/2/22.
//

import SwiftUI

struct GameBallView: View {
    @ObservedObject var gameBallViewModel: GameBallViewModel

    var body: some View {
        Image(ViewConstants.ballImage)
            .resizable()
            .frame(width: gameBallViewModel.ballDiameter, height: gameBallViewModel.ballDiameter)
            .position(gameBallViewModel.ballCenter)
    }
}
