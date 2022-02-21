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

    var boardObjects: [Shape] {
        pegs.map({ $0 as Shape }) + blocks.map({ $0 as Shape })
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
        let canAddPeg = canFit(peg) && !hasOverlapWithExistingObjects(peg)

        guard canAddPeg else {
            return
        }

        peg.parentBoard = self
        pegs.insert(peg)
    }

    func addBlock(_ block: Block) {
        guard !hasOverlapWithExistingObjects(block) else {
            return
        }

        blocks.insert(block)
    }

    func movePeg(peg: Peg, to newCenter: CGPoint) {
        guard pegs.contains(peg) else {
            return
        }

        let pegAtNewCenter = Peg(from: peg, newCenter: newCenter)

        let canMovePeg = canFit(pegAtNewCenter) && !hasOverlapWithExistingObjects(pegAtNewCenter, except: peg)

        guard canMovePeg else {
            return
        }

        pegs.remove(peg)
        peg.move(to: newCenter)
        pegs.insert(peg)
    }

    func scalePeg(peg: Peg, scale: CGFloat) {
        guard pegs.contains(peg) else {
            return
        }

        let scaledPeg = Peg(from: peg, newRadius: peg.radius * scale)

        let canScalePeg = canFit(scaledPeg) && !hasOverlapWithExistingObjects(scaledPeg, except: peg)

        guard canScalePeg else {
            return
        }

        pegs.remove(peg)
        peg.radius *= scale
        pegs.insert(peg)
    }

    func removePeg(_ peg: Peg) {
        pegs.remove(peg)
    }

    func removeAllPegs() {
        pegs = []
    }

    private func canFit(_ circle: Circular) -> Bool {
        let boardRectangle = CGRect(origin: .zero, size: size)

        let objectRectangle = CGRect(from: circle)

        return boardRectangle.contains(objectRectangle)
    }

    private func hasOverlapWithExistingObjects(_ object: Shape, except objectToExclude: Shape) -> Bool {
        boardObjects.contains(where: { $0 !== objectToExclude && $0.overlaps(with: object) })
    }

    private func hasOverlapWithExistingObjects(_ object: Shape) -> Bool {
        boardObjects.contains(where: { $0.overlaps(with: object) })
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
        return entity
    }
}
