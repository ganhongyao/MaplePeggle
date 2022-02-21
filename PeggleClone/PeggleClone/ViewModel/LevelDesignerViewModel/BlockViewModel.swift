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

    var vertex1: CGPoint {
        block.vertex1
    }

    var vertex2: CGPoint {
        block.vertex2
    }

    var vertex3: CGPoint {
        block.vertex3
    }
}
