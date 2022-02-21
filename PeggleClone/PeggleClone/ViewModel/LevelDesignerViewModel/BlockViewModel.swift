//
//  BlockViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 21/2/22.
//

import Foundation
import CoreGraphics

class BlockViewModel: ObservableObject {
    @Published private var block: Block

    private unowned var levelDesignerBoardViewModel: LevelDesignerBoardViewModel

    init(block: Block, levelDesignerBoardViewModel: LevelDesignerBoardViewModel) {
        self.block = block
        self.levelDesignerBoardViewModel = levelDesignerBoardViewModel
    }

    var blockId: UUID? {
        block.id
    }

    var vertices: [CGPoint] {
        block.vertices
    }

    var isSelected: Bool {
        levelDesignerBoardViewModel.selectedObject === block
    }

    func moveBlock(to newCentroid: CGPoint) {
        levelDesignerBoardViewModel.moveBlock(block: block, to: newCentroid)

        objectWillChange.send()
    }

    func moveVertex(vertexIdx: Int, to newLocation: CGPoint) {
        levelDesignerBoardViewModel.moveBlockVertex(block: block, vertexIdx: vertexIdx, to: newLocation)

        objectWillChange.send()
    }

    func selectBlock() {
        levelDesignerBoardViewModel.select(object: block)
    }

    func removeBlock() {
        levelDesignerBoardViewModel.removeBlock(block)
    }
}
