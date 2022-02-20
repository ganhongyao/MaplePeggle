//
//  ControlsViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 20/1/22.
//

import Foundation

class ControlsViewModel: ObservableObject {
    private unowned var levelDesignerViewModel: LevelDesignerViewModel

    var levelName: String {
        get {
            levelDesignerViewModel.boardViewModel?.board.name ?? ""
        }

        set {
            levelDesignerViewModel.boardViewModel?.board.name = newValue
        }
    }

    var board: Board? {
        levelDesignerViewModel.boardViewModel?.board
    }

    init(levelDesignerViewModel: LevelDesignerViewModel) {
        self.levelDesignerViewModel = levelDesignerViewModel
    }

    func save() {
        levelDesignerViewModel.saveBoard()
    }

    func reset() {
        levelDesignerViewModel.boardViewModel?.removeAllPegs()
    }
}
