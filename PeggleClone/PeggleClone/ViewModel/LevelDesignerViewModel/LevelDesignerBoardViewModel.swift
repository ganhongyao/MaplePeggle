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

    private(set) var selectedObject: BoardObject?

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

    var blockViewModels: [BlockViewModel] {
        board.blocks.map({ BlockViewModel(block: $0, levelDesignerBoardViewModel: self)})
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

    var blockCount: Int {
        board.blocks.count
    }

    var snapshot: Data? {
        get {
            board.snapshot
        }

        set {
            board.snapshot = newValue
        }
    }

    var isInAddPegMode: Bool {
        levelDesignerViewModel.pegSelectorViewModel?.isInAddPegMode ?? false
    }

    var isInAddBlockMode: Bool {
        levelDesignerViewModel.pegSelectorViewModel?.isInAddBlockMode ?? false
    }

    var isInDeleteMode: Bool {
        levelDesignerViewModel.pegSelectorViewModel?.isInDeleteMode ?? false
    }

    func setSnapshot(snapshotImage: UIImage) {
        board.snapshot = snapshotImage.pngData()
    }

    func getPegCount(color: Peg.Color) -> Int {
        board.pegs.filter { $0.color == color }.count
    }

    func select(object: BoardObject?) {
        selectedObject = object

        objectWillChange.send()
    }

    func scaleBoardObject(factor: CGFloat) {
        guard let selectedObject = selectedObject else {
            return
        }

        if let selectedPeg = selectedObject as? Peg {
            board.scalePeg(peg: selectedPeg, scaleFactor: factor)
        }

        if let selectedBlock = selectedObject as? Block {
            board.scaleBlock(block: selectedBlock, scaleFactor: factor)
        }

        objectWillChange.send()
    }

    func rotateBoardObject(angle: CGFloat) {
        guard let selectedObject = selectedObject else {
            return
        }

        if let selectedPeg = selectedObject as? Peg {
            board.rotatePeg(peg: selectedPeg, angle: angle)
        }

        if let selectedBlock = selectedObject as? Block {
            board.rotateBlock(block: selectedBlock, angle: angle)
        }

        objectWillChange.send()
    }

    func addPeg(center: CGPoint) {
        guard let selectedPegColor = levelDesignerViewModel.pegSelectorViewModel?.selectedPegColor else {
            return
        }

        let newPeg = Peg(center: center, radius: Peg.defaultRadius, color: selectedPegColor)

        board.addPeg(newPeg)

        objectWillChange.send()
    }

    func addBlock(center: CGPoint) {
        let newBlock = Block(center: center)

        board.addBlock(newBlock)

        objectWillChange.send()
    }

    func movePeg(peg: Peg, to newCenter: CGPoint) {
        board.movePeg(peg: peg, to: newCenter)

        objectWillChange.send()
    }

    func moveBlock(block: Block, to newCentroid: CGPoint) {
        board.moveBlock(block: block, to: newCentroid)

        objectWillChange.send()
    }

    func moveBlockVertex(block: Block, vertexIdx: Int, to newLocation: CGPoint) {
        board.moveBlockVertex(block: block, vertexIdx: vertexIdx, to: newLocation)

        objectWillChange.send()
    }

    func removePeg(_ peg: Peg) {
        board.removePeg(peg)

        objectWillChange.send()
    }

    func removeBlock(_ block: Block) {
        board.removeBlock(block)

        objectWillChange.send()
    }

    func removeAllBoardObjects() {
        board.removeAllPegs()
        board.removeAllBlocks()

        objectWillChange.send()
    }
}
