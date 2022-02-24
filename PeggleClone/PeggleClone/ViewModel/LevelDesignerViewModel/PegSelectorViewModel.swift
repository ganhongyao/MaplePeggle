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

    private var levelDesignerViewModel: LevelDesignerViewModel

    @Published var blueCount = 0
    @Published var orangeCount = 0
    @Published var greenCount = 0
    @Published var blockCount = 0

    init(levelDesignerViewModel: LevelDesignerViewModel) {
        self.levelDesignerViewModel = levelDesignerViewModel
        self.blueCount = getInitialPegCountForColor(color: .blue)
        self.orangeCount = getInitialPegCountForColor(color: .orange)
        self.greenCount = getInitialPegCountForColor(color: .green)
        self.blockCount = getInitialBlockCount()
    }

    var isInAddPegMode: Bool {
        !isInDeleteMode && !isInAddBlockMode
    }

    var pegColorsAndCounts: [(Peg.Color, Int)] {
        [
            (.blue, blueCount),
            (.orange, orangeCount),
            (.green, greenCount)
        ]
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

    private func getInitialPegCountForColor(color: Peg.Color) -> Int {
        levelDesignerViewModel.boardViewModel?.pegViewModels.filter { $0.color == color }.count ?? 0
    }

    private func getInitialBlockCount() -> Int {
        levelDesignerViewModel.boardViewModel?.blockViewModels.count ?? 0
    }

    func increasePegCountForColor(color: Peg.Color) {
        switch color {
        case .blue:
            blueCount += 1
        case .orange:
            orangeCount += 1
        case .green:
            greenCount += 1
        }
    }

    func increaseBlockCount() {
        blockCount += 1
    }
}
