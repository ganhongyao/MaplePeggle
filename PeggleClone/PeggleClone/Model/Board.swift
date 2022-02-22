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

    var size: CGSize

    let dateCreated: Date?

    var snapshot: Data?

    private(set) var pegs: Set<Peg>

    private(set) var blocks: Set<Block>

    var boardObjects: [BoardObject] {
        pegs.map({ $0 as BoardObject }) + blocks.map({ $0 as BoardObject })
    }

    required init(id: UUID?, name: String, size: CGSize, snapshot: Data?, pegs: Set<Peg>, blocks: Set<Block>,
                  dateCreated: Date? = Date()) {
        self.id = id
        self.name = name
        self.size = size
        self.dateCreated = dateCreated
        self.snapshot = snapshot
        self.pegs = pegs
        self.blocks = blocks

        pegs.forEach { $0.parentBoard = self }
    }

    convenience init(name: String, size: CGSize) {
        self.init(id: UUID(), name: name, size: size, snapshot: nil, pegs: [], blocks: [], dateCreated: Date())
    }

    func addPeg(_ peg: Peg) {
        guard isAtLegalPosition(peg) else {
            return
        }

        peg.parentBoard = self
        pegs.insert(peg)
    }

    func addBlock(_ block: Block) {
        guard isAtLegalPosition(block) else {
            return
        }

        blocks.insert(block)
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
                         size: CGSize(width: managedObject.width, height: managedObject.height),
                         snapshot: managedObject.snapshot,
                         pegs: pegs,
                         blocks: blocks,
                         dateCreated: managedObject.dateCreated)

        return board
    }

    func toManagedObject() -> BoardEntity {
        let entity = CoreDataManager.sharedInstance.makeCoreDataEntity(class: Board.self)
        entity.id = id
        entity.name = name
        entity.width = size.width
        entity.height = size.height
        let pegEntities: [PegEntity] = pegs.map({ peg in
            let pegEntity = peg.toManagedObject()
            pegEntity.parentBoard = entity
            return pegEntity
        })
        entity.dateCreated = dateCreated
        entity.snapshot = snapshot
        entity.pegs = NSSet(array: pegEntities)
        entity.blocks = NSSet(array: blocks.map({ $0.toManagedObject() }))
        return entity
    }
}
