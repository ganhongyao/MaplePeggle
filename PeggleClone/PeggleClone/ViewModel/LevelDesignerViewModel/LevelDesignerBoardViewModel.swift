//
//  BoardViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 27/1/22.
//

import Foundation
import CoreGraphics
import SwiftUI

class LevelDesignerBoardViewModel: ObservableObject {
    private(set) var board = Board.makeNewBoard()

    @Published private(set) var isNewBoard = true

    @Published var isShowingError = false

    @Published var error: PersistenceError?

    private(set) var selectedPeg: Peg?

    private unowned var levelDesignerViewModel: LevelDesignerViewModel

    init(boardId: UUID?, levelDesignerViewModel: LevelDesignerViewModel) {
        self.levelDesignerViewModel = levelDesignerViewModel

        guard let boardId = boardId else {
            return
        }

        isNewBoard = false

        do {
            guard let fetchedBoard: Board = try CoreDataManager.sharedInstance.fetchWithId(id: boardId) else {
                return
            }

            board = fetchedBoard

        } catch let persistenceError as PersistenceError {
            isShowingError = true
            error = persistenceError
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    var pegViewModels: [PegViewModel] {
        board.pegs.map({ PegViewModel(peg: $0, levelDesignerBoardViewModel: self)})
    }

    var boardSize: CGSize {
        get {
            board.size
        }

        set {
            board.size = newValue

            objectWillChange.send()
        }
    }

    var snapshot: Data? {
        get {
            board.snapshot
        }

        set {
            board.snapshot = newValue
        }
    }

    var isInDeleteMode: Bool {
        levelDesignerViewModel.pegSelectorViewModel.isInDeleteMode
    }

    func setSnapshot(snapshotImage: UIImage) {
        board.snapshot = snapshotImage.pngData()
    }

    func selectPeg(peg: Peg) {
        selectedPeg = peg

        objectWillChange.send()
    }

    func scaleBoardItem(scale: CGFloat) {
        guard let selectedPeg = selectedPeg else {
            return
        }

        board.scaleBoardObject(boardObject: selectedPeg, scale: scale)

        objectWillChange.send()
    }

    func addPeg(center: CGPoint) {
        let newPeg = Peg(center: center, radius: Peg.defaultRadius,
                         color: levelDesignerViewModel.pegSelectorViewModel.selectedPegColor)

        board.addPeg(newPeg)

        objectWillChange.send()
    }

    func movePeg(peg: Peg, to newCenter: CGPoint) {
        board.movePeg(peg: peg, to: newCenter)

        objectWillChange.send()
    }

    func removePeg(_ peg: Peg) {
        board.removePeg(peg)

        objectWillChange.send()
    }

    func removeAllPegs() {
        board.removeAllPegs()

        objectWillChange.send()
    }
}
