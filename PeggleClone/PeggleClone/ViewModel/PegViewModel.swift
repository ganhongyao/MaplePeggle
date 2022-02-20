//
//  PegViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 24/1/22.
//

import Foundation
import CoreGraphics

class PegViewModel: ObservableObject {
    @Published private var peg: Peg

    private unowned var levelDesignerBoardViewModel: LevelDesignerBoardViewModel

    init(peg: Peg, levelDesignerBoardViewModel: LevelDesignerBoardViewModel) {
        self.peg = peg
        self.levelDesignerBoardViewModel = levelDesignerBoardViewModel
    }

    var center: CGPoint {
        peg.center
    }

    var diameter: CGFloat {
        peg.diameter
    }

    var color: Peg.Color {
        peg.color
    }

    func movePeg(to newCenter: CGPoint) {
        levelDesignerBoardViewModel.movePeg(peg: peg, to: newCenter)

        objectWillChange.send()
    }
}
