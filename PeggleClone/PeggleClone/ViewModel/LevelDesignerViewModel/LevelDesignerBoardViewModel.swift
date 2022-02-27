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

    var selectedObjects: [BoardObject] = []

    var scaleFactor: CGFloat = 1.0

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

    var isInMultiselectMode: Bool {
        levelDesignerViewModel.pegSelectorViewModel?.isInMultiselectMode ?? false
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

    func unselectAllObjects() {
        selectedObjects = []

        objectWillChange.send()
    }

    func unselect(object: BoardObject) {
        guard selectedObjects.contains(where: { $0 === object }) else {
            return
        }

        selectedObjects.removeAll { $0 === object }

        objectWillChange.send()
    }

    func select(object: BoardObject) {
        guard !selectedObjects.contains(where: { $0 === object }) else {
            return
        }

        if !isInMultiselectMode {
            unselectAllObjects()
        }

        selectedObjects.append(object)

        objectWillChange.send()
    }

    func scaleBoard() {
        board.baseSize = CGSize(width: board.baseSize.width * scaleFactor,
                                height: board.baseSize.height * scaleFactor)
        board.size = CGSize(width: board.size.width * scaleFactor,
                            height: board.size.height * scaleFactor)

        for block in board.blocks {
            let newCentroid = CGPoint(x: block.centroid.x * scaleFactor, y: block.centroid.y * scaleFactor)
            block.scale(factor: scaleFactor)
            block.move(to: newCentroid)
        }

        for peg in board.pegs {
            let newCenter = CGPoint(x: peg.center.x * scaleFactor, y: peg.center.y * scaleFactor)
            peg.scale(factor: scaleFactor)
            peg.move(to: newCenter)
        }

        objectWillChange.send()
    }

    func moveBoardObjects(offset: CGVector) {
        selectedObjects.forEach { moveBoardObject(object: $0, offset: offset) }
    }

    func moveBoardObject(object: BoardObject, offset: CGVector) {
        if let selectedPeg = object as? Peg {
            board.movePeg(peg: selectedPeg, offset: offset)
        }

        if let selectedBlock = object as? Block {
            board.moveBlock(block: selectedBlock, offset: offset)
        }

        objectWillChange.send()
    }

    func scaleBoardObjects(factor: CGFloat) {
        selectedObjects.forEach { scaleBoardObject(object: $0, factor: factor) }
    }

    func scaleBoardObject(object: BoardObject, factor: CGFloat) {
        if let selectedPeg = object as? Peg {
            board.scalePeg(peg: selectedPeg, scaleFactor: factor)
        }

        if let selectedBlock = object as? Block {
            board.scaleBlock(block: selectedBlock, scaleFactor: factor)
        }

        objectWillChange.send()
    }

    func rotateBoardObjects(angle: CGFloat) {
        selectedObjects.forEach { rotateBoardObject(object: $0, angle: angle) }
    }

    func rotateBoardObject(object: BoardObject, angle: CGFloat) {
        if let selectedPeg = object as? Peg {
            board.rotatePeg(peg: selectedPeg, angle: angle)
        }

        if let selectedBlock = object as? Block {
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

        let isAdded = board.addPeg(newPeg)

        if isAdded {
            AudioPlayer.sharedInstance.play(sound: .tap)
        }

        objectWillChange.send()
    }

    func addBlock(center: CGPoint) {
        let actualCenter = getActualBoardPosition(point: center)

        let newBlock = Block(center: actualCenter)

        let isAdded = board.addBlock(newBlock)

        if isAdded {
            AudioPlayer.sharedInstance.play(sound: .tap)
        }

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
