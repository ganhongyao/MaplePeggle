//
//  Board.swift
//  PeggleClone
//
//  Created by Hong Yao on 18/1/22.
//

import Foundation
import CoreGraphics
import PhysicsEngine

class Board {
    static let defaultBoardNameIfEmpty = "Untitled"

    let id: UUID?

    var name: String

    /// Size of the board before extra height was added through scrolling
    var baseSize: CGSize

    var size: CGSize

    let dateCreated: Date?

    var snapshot: Data?

    let isSeedData: Bool

    private(set) var pegs: Set<Peg>

    private(set) var blocks: Set<Block>

    var boardObjects: [BoardObject] {
        pegs.map({ $0 as BoardObject }) + blocks.map({ $0 as BoardObject })
    }

    var unusedHeightAtBottom: CGFloat {
        size.height - maxObjectYCoordinate
    }

    private var maxObjectYCoordinate: CGFloat {
        let maxPegYCoordinate = pegs.reduce(0.0, { currMax, peg in
            max(currMax, peg.center.y + peg.radius)
        })

        let maxBlockYCoordinate = blocks.reduce(0.0, { currMax, block in
            max(currMax, block.maxY)
        })

        return max(maxPegYCoordinate, maxBlockYCoordinate)
    }

    required init(id: UUID? = UUID(), name: String, baseSize: CGSize, size: CGSize, snapshot: Data?, pegs: Set<Peg>, blocks: Set<Block>,
                  dateCreated: Date? = Date(), isSeedData: Bool = false) {
        self.id = id
        self.name = name
        self.baseSize = baseSize
        self.size = size
        self.dateCreated = dateCreated
        self.snapshot = snapshot
        self.isSeedData = isSeedData
        self.pegs = pegs
        self.blocks = blocks
    }

    convenience init(name: String, size: CGSize) {
        self.init(id: UUID(), name: name, baseSize: size, size: size, snapshot: nil, pegs: [], blocks: [], dateCreated: Date())
    }

    static func makeBoardFromTemplate(templateBoard: Board) -> Board {
        let pegs = templateBoard.pegs.map { peg in
            Peg(center: peg.center, radius: peg.radius, facingAngle: peg.facingAngle, color: peg.color)
        }

        let blocks = templateBoard.blocks.map { block in
            Block(vertices: block.vertices)
        }

        return Board(name: "", baseSize: templateBoard.baseSize, size: templateBoard.size, snapshot: templateBoard.snapshot, pegs: Set(pegs), blocks: Set(blocks))
    }

    @discardableResult func addPeg(_ peg: Peg) -> Bool {
        guard isAtLegalPosition(peg) else {
            return false
        }

        pegs.insert(peg)
        return true
    }

    @discardableResult func addBlock(_ block: Block) -> Bool {
        guard isAtLegalPosition(block) else {
            return false
        }

        blocks.insert(block)
        return true
    }

    func movePeg(peg: Peg, to newCenter: CGPoint) {
        guard pegs.contains(peg) else {
            return
        }

        let pegAtNewCenter = Peg(from: peg, newCenter: newCenter)

        guard isAtLegalPosition(pegAtNewCenter) else {
            return
        }

        peg.move(to: newCenter)
    }

    func movePeg(peg: Peg, offset: CGVector) {
        let newCenter = peg.center.offset(vector: offset)

        movePeg(peg: peg, to: newCenter)
    }

    func moveBlock(block: Block, to newCentroid: CGPoint) {
        guard blocks.contains(block) else {
            return
        }

        let movedBlock = Block(from: block)
        movedBlock.move(to: newCentroid)

        guard isAtLegalPosition(movedBlock) else {
            return
        }

        block.move(to: newCentroid)
    }

    func moveBlock(block: Block, offset: CGVector) {
        let newCentroid = block.centroid.offset(vector: offset)

        moveBlock(block: block, to: newCentroid)
    }

    func moveBlockVertex(block: Block, vertexIdx: Int, to newLocation: CGPoint) {
        guard blocks.contains(block) else {
            return
        }

        let movedBlock = Block(from: block)
        movedBlock.vertices[vertexIdx] = newLocation

        guard isAtLegalPosition(movedBlock) else {
            return
        }

        block.vertices[vertexIdx] = newLocation
    }

    func scalePeg(peg: Peg, scaleFactor: CGFloat) {
        guard pegs.contains(peg) else {
            return
        }

        let scaledPeg = Peg(from: peg)
        scaledPeg.scale(factor: scaleFactor)

        guard isAtLegalPosition(scaledPeg) else {
            return
        }

        peg.scale(factor: scaleFactor)
    }

    func scaleBlock(block: Block, scaleFactor: CGFloat) {
        guard blocks.contains(block) else {
            return
        }

        let scaledBlock = Block(from: block)
        scaledBlock.scale(factor: scaleFactor)

        guard isAtLegalPosition(scaledBlock) else {
            return
        }

        block.scale(factor: scaleFactor)
    }

    func rotatePeg(peg: Peg, angle: CGFloat) {
        guard pegs.contains(peg) else {
            return
        }

        let rotatedPeg = Peg(from: peg)
        rotatedPeg.rotate(angle: angle)

        guard isAtLegalPosition(rotatedPeg) else {
            return
        }

        peg.rotate(angle: angle)
    }

    func rotateBlock(block: Block, angle: CGFloat) {
        guard blocks.contains(block) else {
            return
        }

        let rotatedBlock = Block(from: block)
        rotatedBlock.rotate(angle: angle)

        guard isAtLegalPosition(rotatedBlock) else {
            return
        }

        block.rotate(angle: angle)
    }

    func removePeg(_ peg: Peg) {
        pegs.remove(peg)
    }

    func removeBlock(_ block: Block) {
        blocks.remove(block)
    }

    func removeAllPegs() {
        pegs = []
    }

    func removeAllBlocks() {
        blocks = []
    }

    private func isAtLegalPosition(_ object: BoardObject) -> Bool {
        canFit(object) && !hasOverlapWithExistingObjects(object)
    }

    private func canFit(_ object: BoardObject) -> Bool {
        let boardRectangle = CGRect(origin: .zero, size: size)
        let objectRectangle = CGRect(from: object)

        return boardRectangle.contains(objectRectangle)
    }

    private func hasOverlapWithExistingObjects(_ object: BoardObject) -> Bool {
        boardObjects.contains(where: { $0.id != object.id && $0.overlaps(with: object) })
    }

    static func makeNewBoard() -> Board {
        Board(name: "", size: .zero)
    }
}

extension Board: CustomStringConvertible {
    var description: String {
        "Board: { id: \(String(describing: id)), name: \(name), size: \(size), pegs: \(pegs) }"
    }
}

// MARK: Equatable
extension Board: Equatable {
    static func == (lhs: Board, rhs: Board) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.size == rhs.size &&
        lhs.dateCreated == rhs.dateCreated &&
        lhs.snapshot == rhs.snapshot &&
        lhs.pegs == rhs.pegs
    }
}

// MARK: Persistable
extension Board: Persistable {
    typealias ManagedObject = BoardEntity

    static func fromManagedObject(_ managedObject: BoardEntity) -> Self {
        var pegs = Set<Peg>()
        if let pegEntities = managedObject.pegs?.allObjects as? [PegEntity] {
            pegs = Set(pegEntities.map(Peg.fromManagedObject))
        }

        var blocks = Set<Block>()
        if let blockEntities = managedObject.blocks?.allObjects as? [BlockEntity] {
            blocks = Set(blockEntities.map(Block.fromManagedObject))
        }

        let board = Self(id: managedObject.id,
                         name: managedObject.name ?? "",
                         baseSize: CGSize(width: managedObject.baseWidth, height: managedObject.baseHeight),
                         size: CGSize(width: managedObject.width, height: managedObject.height),
                         snapshot: managedObject.snapshot,
                         pegs: pegs,
                         blocks: blocks,
                         dateCreated: managedObject.dateCreated,
                         isSeedData: managedObject.isSeedData
        )

        return board
    }

    func toManagedObject() -> BoardEntity {
        let entity = CoreDataManager.sharedInstance.makeCoreDataEntity(class: Board.self)
        entity.id = id
        entity.name = name
        entity.baseWidth = baseSize.width
        entity.baseHeight = baseSize.height
        entity.width = size.width
        entity.height = size.height
        entity.dateCreated = dateCreated
        entity.snapshot = snapshot
        entity.isSeedData = isSeedData
        entity.pegs = NSSet(array: pegs.map({ $0.toManagedObject() }))
        entity.blocks = NSSet(array: blocks.map({ $0.toManagedObject() }))
        return entity
    }
}
