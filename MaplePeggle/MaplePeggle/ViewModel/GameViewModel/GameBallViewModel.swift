//
//  GameBallViewModel.swift
//  MaplePeggle
//
//  Created by Hong Yao on 4/2/22.
//

import Foundation
import CoreGraphics

class GameBallViewModel: ObservableObject {
    @Published private var gameBall: GameBall

    init(gameBall: GameBall) {
        self.gameBall = gameBall
    }

    var ballCenter: CGPoint {
        gameBall.center
    }

    var ballDiameter: CGFloat {
        gameBall.diameter
    }
}
