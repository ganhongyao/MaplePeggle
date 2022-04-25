//
//  GameBlockViewModel.swift
//  MaplePeggle
//
//  Created by Hong Yao on 22/2/22.
//

import Foundation
import CoreGraphics

class GameBlockViewModel: ObservableObject {
    @Published private var gameBlock: GameBlock

    init(gameBlock: GameBlock) {
        self.gameBlock = gameBlock
    }

    var vertices: [CGPoint] {
        gameBlock.vertices
    }
}
