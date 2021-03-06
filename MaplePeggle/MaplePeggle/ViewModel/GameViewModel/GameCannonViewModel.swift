//
//  GameCannonViewModel.swift
//  MaplePeggle
//
//  Created by Hong Yao on 8/2/22.
//

import Foundation
import CoreGraphics

class GameCannonViewModel: ObservableObject {
    @Published private var gameCannon: GameCannon

    init(gameCannon: GameCannon) {
        self.gameCannon = gameCannon
    }

    var cannonHeight: CGFloat {
        get {
            gameCannon.height
        }

        set {
            gameCannon.height = newValue

            objectWillChange.send()
        }
    }

    var cannonPosition: CGPoint {
        get {
            gameCannon.center
        }

        set {
            gameCannon.center = newValue

            objectWillChange.send()
        }
    }

    var rotationAngle: CGFloat {
        gameCannon.rotationAngle
    }

    var isAimingAtSelf: Bool {
        gameCannon.isAimingAtSelf
    }

    func aim(towards aimedLocation: CGPoint) {
        gameCannon.aim(towards: aimedLocation)

        objectWillChange.send()
    }
}
