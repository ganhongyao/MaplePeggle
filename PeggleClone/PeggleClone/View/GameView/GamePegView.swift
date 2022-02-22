//
//  GamePegView.swift
//  PeggleClone
//
//  Created by Hong Yao on 4/2/22.
//

import SwiftUI

struct GamePegView: View {
    @ObservedObject var gamePegViewModel: GamePegViewModel

    var body: some View {
        getPegImage(color: gamePegViewModel.pegColor, isLit: gamePegViewModel.isLit)
            .resizable()
            .frame(width: gamePegViewModel.pegDiameter, height: gamePegViewModel.pegDiameter)
            .rotationEffect(.radians(gamePegViewModel.pegFacingAngle))
            .position(gamePegViewModel.pegCenter)
    }
}
