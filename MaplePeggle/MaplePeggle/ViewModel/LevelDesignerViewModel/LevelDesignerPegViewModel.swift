//
//  PegViewModel.swift
//  MaplePeggle
//
//  Created by Hong Yao on 24/1/22.
//

import Foundation
import CoreGraphics

class LevelDesignerPegViewModel: ObservableObject {
    @Published private var peg: Peg

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

    var radius: CGFloat {
        peg.radius
    }

    var diameter: CGFloat {
        peg.diameter
    }

    var facingAngle: CGFloat {
        peg.facingAngle
    }

    var color: Peg.Color {
        peg.color
    }

    var isSelected: Bool {
        levelDesignerBoardViewModel.selectedObjects.contains { $0 === peg }
    }

    func toggleSelected() {
        isSelected ? unselectPeg() : selectPeg()
    }

    func selectPeg() {
        levelDesignerBoardViewModel.select(object: peg)
    }

    func unselectPeg() {
        levelDesignerBoardViewModel.unselect(object: peg)
    }

    func movePeg(to newCenter: CGPoint) {
        levelDesignerBoardViewModel.movePeg(peg: peg, to: newCenter)

        objectWillChange.send()
    }

    func removePeg() {
        levelDesignerBoardViewModel.removePeg(peg)
    }
}
