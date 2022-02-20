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

    var pegColors: [Peg.Color] {
        Peg.Color.allCases
    }

    func setSelectedPegColor(color: Peg.Color) {
        selectedPegColor = color
    }

    func enableDeleteMode() {
        isInDeleteMode = true
    }

    func disableDeleteMode() {
        isInDeleteMode = false
    }
}
