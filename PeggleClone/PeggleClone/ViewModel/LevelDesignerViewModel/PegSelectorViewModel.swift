//
//  PegSelectorViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 27/1/22.
//

import Foundation

class PegSelectorViewModel: ObservableObject {
    @Published private(set) var selectedPegColor: Peg.Color = .blue
    @Published private(set) var isInDeleteMode = false
    @Published private(set) var isInAddBlockMode = false

    var isInAddPegMode: Bool {
        !isInDeleteMode && !isInAddBlockMode
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
        isInDeleteMode = false
    }

    func enterAddBlockMode() {
        isInAddBlockMode = true
        isInDeleteMode = false
    }

    func enterDeleteMode() {
        isInDeleteMode = true
        isInAddBlockMode = false
    }
}
