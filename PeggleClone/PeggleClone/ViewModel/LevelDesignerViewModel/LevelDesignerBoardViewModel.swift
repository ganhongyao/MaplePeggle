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

            board = fetchedBoard.isSeedData ? Board.makeBoardFromSeedData(board: fetchedBoard) : fetchedBoard

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

    var boardBaseSize: CGSize {
        get {
            board.baseSize
        }

        set {
            board.baseSize = newValue

            objectWillChange.send()
        }
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

    private var trimmedHeight: CGFloat = .zero

    var amountScrolledDownwards: CGFloat = .zero {
        didSet {
            let amountUnscrolled = amountScrolledDownwards - oldValue
            unscrolledHeight = max(unscrolledHeight - amountUnscrolled, 0)

            objectWillChange.send()
        }
    }

    var unscrolledHeight: CGFloat = .zero {
        didSet {
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

    private func getActualBoardPosition(point: CGPoint) -> CGPoint {
        point.offset(y: amountScrolledDownwards)
    }

    func addPeg(center: CGPoint) {
        guard let selectedPegColor = levelDesignerViewModel.pegSelectorViewModel?.selectedPegColor else {
            return
        }

        let actualCenter = getActualBoardPosition(point: center)

        let newPeg = Peg(center: actualCenter, radius: Peg.defaultRadius, color: selectedPegColor)

        board.addPeg(newPeg)

        objectWillChange.send()
    }

    func addBlock(center: CGPoint) {
        let actualCenter = getActualBoardPosition(point: center)

        let newBlock = Block(center: actualCenter)

        board.addBlock(newBlock)

        objectWillChange.send()
    }

    func movePeg(peg: Peg, to newCenter: CGPoint) {
        let actualNewCenter = getActualBoardPosition(point: newCenter)

        board.movePeg(peg: peg, to: actualNewCenter)

        objectWillChange.send()
    }

    func moveBlock(block: Block, to newCentroid: CGPoint) {
        let actualNewCentroid = getActualBoardPosition(point: newCentroid)

        board.moveBlock(block: block, to: actualNewCentroid)

        objectWillChange.send()
    }

    func moveBlockVertex(block: Block, vertexIdx: Int, to newLocation: CGPoint) {
        let actualNewLocation = getActualBoardPosition(point: newLocation)

        board.moveBlockVertex(block: block, vertexIdx: vertexIdx, to: actualNewLocation)

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

    func trimAddedButUnusedHeight() {
        let totalAddedHeight = amountScrolledDownwards + unscrolledHeight

        let unusedHeight = boardSize.height - board.maxObjectYCoordinate

        trimmedHeight = min(unusedHeight, totalAddedHeight)

        if unusedHeight < totalAddedHeight {
            boardSize.height -= unusedHeight
        } else {
            boardSize.height -= totalAddedHeight
        }
    }

    func addBackTrimmedHeightForEditing() {
        boardSize.height += trimmedHeight
    }
}
