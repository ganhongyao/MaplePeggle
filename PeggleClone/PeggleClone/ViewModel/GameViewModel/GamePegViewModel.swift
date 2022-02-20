//
//  GamePegViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 4/2/22.
//

import Foundation
import CoreGraphics

class GamePegViewModel: ObservableObject {
    @Published private var gamePeg: GamePeg

    init(gamePeg: GamePeg) {
        self.gamePeg = gamePeg
    }

    var pegColor: Peg.Color {
        gamePeg.color
    }

    var pegCenter: CGPoint {
        gamePeg.center
    }

    var pegDiameter: CGFloat {
        gamePeg.diameter
    }

    var isLit: Bool {
        gamePeg.collisionCount > 0
    }
}
