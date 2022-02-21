//
//  PegViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 24/1/22.
//

import Foundation
import CoreGraphics

class PegViewModel: ObservableObject {
    @Published private(set) var peg: Peg

    private unowned var levelDesignerBoardViewModel: LevelDesignerBoardViewModel

    init(peg: Peg, levelDesignerBoardViewModel: LevelDesignerBoardViewModel) {
        self.peg = peg
        self.levelDesignerBoardViewModel = levelDesignerBoardViewModel
    }

    var pegId: UUID? {
        peg.id
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

    var isSelected: Bool {
        levelDesignerBoardViewModel.selectedObject === peg
    }

    func selectPeg() {
        levelDesignerBoardViewModel.select(object: peg)
    }

    func movePeg(to newCenter: CGPoint) {
        levelDesignerBoardViewModel.movePeg(peg: peg, to: newCenter)

        objectWillChange.send()
    }

    func removePeg() {
        levelDesignerBoardViewModel.removePeg(peg)
    }
}
