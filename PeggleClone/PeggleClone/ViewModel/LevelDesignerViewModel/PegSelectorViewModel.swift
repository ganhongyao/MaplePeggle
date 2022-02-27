//
//  PegSelectorViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 27/1/22.
//

import Foundation

class PegSelectorViewModel: ObservableObject {
    @Published private(set) var selectedPegColor: Peg.Color = .blue

    @Published private(set) var isInAddBlockMode = false
    @Published private(set) var isInMultiselectMode = false {
        didSet {
            guard !isInMultiselectMode else {
                return
            }

            levelDesignerViewModel.boardViewModel?.unselectAllObjects()
        }
    }
    @Published private(set) var isInDeleteMode = false

    private var levelDesignerViewModel: LevelDesignerViewModel

    init(levelDesignerViewModel: LevelDesignerViewModel) {
        self.levelDesignerViewModel = levelDesignerViewModel
    }

    var isInAddPegMode: Bool {
        !isInDeleteMode && !isInAddBlockMode && !isInMultiselectMode
    }

    var pegColors: [Peg.Color] {
        Peg.Color.allCases
    }

    func setSelectedPegColor(color: Peg.Color) {
        selectedPegColor = color
        enterAddPegMode()
    }

    func enterAddPegMode() {
        isInAddBlockMode = false
        isInMultiselectMode = false
        isInDeleteMode = false
    }

    func enterAddBlockMode() {
        isInAddBlockMode = true
        isInMultiselectMode = false
        isInDeleteMode = false
    }

    func enterMultiselectMode() {
        isInAddBlockMode = false
        isInMultiselectMode = true
        isInDeleteMode = false
    }

    func enterDeleteMode() {
        isInAddBlockMode = false
        isInMultiselectMode = false
        isInDeleteMode = true
    }
}
