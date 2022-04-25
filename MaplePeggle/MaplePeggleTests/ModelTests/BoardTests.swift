//
//  BoardTests.swift
//  MaplePeggleTests
//
//  Created by Hong Yao on 29/1/22.
//

import XCTest
@testable import MaplePeggle

class BoardTests: XCTestCase {

    func testInit() -> Board {
        let uuid = UUID()
        let name = "Test Board"
        let size = CGSize(width: 800, height: 800)
        let currentDate = Date()
        let snapshot: Data? = nil
        let pegs = Set<Peg>()

        let board = Board(id: uuid, name: name, size: size, snapshot: snapshot, pegs: pegs, dateCreated: currentDate)

        XCTAssertNotNil(board)
        XCTAssertEqual(board.id, uuid)
        XCTAssertEqual(board.name, name)
        XCTAssertEqual(board.size, size)
        XCTAssertEqual(board.dateCreated, currentDate)
        XCTAssertEqual(board.snapshot, snapshot)
        XCTAssertEqual(board.pegs, pegs)

        return board
    }

    func testAddPeg_legalPosition_added() {
        let board = testInit()

        let peg1 = Peg(center: CGPoint(x: 500, y: 500), color: .orange)
        board.addPeg(peg1)

        XCTAssertEqual(board.pegs.count, 1)
        XCTAssert(board.pegs.contains(peg1))

        let peg2 = Peg(center: CGPoint(x: 250, y: 250), color: .blue)
        board.addPeg(peg2)

        XCTAssertEqual(board.pegs.count, 2)
        XCTAssert(board.pegs.contains(peg2))
    }

    func testAddPeg_pegOutsideBoard_notAdded() {
        let board = testInit()
        let originalPegCount = board.pegs.count

        let peg = Peg(center: CGPoint(x: 1_000, y: 1_000), color: .orange)

        board.addPeg(peg)

        XCTAssertEqual(board.pegs.count, originalPegCount)
    }

    func testAddPeg_pegOverlapsWithExistingPeg_notAdded() {
        let board = testInit()
        let existingPeg = Peg(center: CGPoint(x: 500, y: 500), color: .orange)
        board.addPeg(existingPeg)
        let originalPegCount = board.pegs.count

        let newPeg = Peg(center: CGPoint(x: 501, y: 501), color: .orange)

        board.addPeg(newPeg)

        XCTAssertEqual(board.pegs.count, originalPegCount)
        XCTAssert(board.pegs.contains(existingPeg))
        XCTAssertFalse(board.pegs.contains(newPeg))
    }

    func testMovePeg_pegNotInBoard_nothingHappens() {
        let board = testInit()

        let pegCenter = CGPoint(x: 500, y: 500)
        let peg = Peg(center: pegCenter, color: .orange)

        board.movePeg(peg: peg, to: CGPoint(x: 300, y: 300))

        XCTAssertEqual(peg.center, pegCenter)
    }

    func testMovePeg_legalPosition_moved() {
        let board = testInit()

        let peg = Peg(center: CGPoint(x: 500, y: 500), color: .orange)
        board.addPeg(peg)

        let newCenter = CGPoint(x: 500, y: 502)
        board.movePeg(peg: peg, to: newCenter)

        XCTAssertEqual(peg.center, newCenter)
        XCTAssertEqual(board.pegs.first?.center, newCenter)
    }

    func testMovePeg_pegOverlapsWithOtherPeg_notMoved() {
        let board = testInit()

        let center1 = CGPoint(x: 500, y: 500)
        let peg1 = Peg(center: center1, color: .orange)
        board.addPeg(peg1)

        let center2 = CGPoint(x: 200, y: 200)
        let peg2 = Peg(center: center2, color: .blue)
        board.addPeg(peg2)

        board.movePeg(peg: peg2, to: CGPoint(x: center1.x + 1, y: center1.y + 1))

        XCTAssertEqual(peg2.center, center2)
    }

    func testRemovePeg_pegExists_removed() {
        let board = testInit()

        let peg = Peg(center: CGPoint(x: 500, y: 500), color: .blue)
        board.addPeg(peg)

        XCTAssertEqual(board.pegs.count, 1)

        board.removePeg(peg)

        XCTAssert(board.pegs.isEmpty)
        XCTAssertFalse(board.pegs.contains(peg))
    }

    func testRemovePeg_pegDoesNotExist_nothingHappens() {
        let board = testInit()

        let peg = Peg(center: CGPoint(x: 500, y: 500), color: .blue)

        board.removePeg(peg)

        XCTAssertEqual(board.pegs.count, 0)
    }

    func testRemoveAllPegs() {
        let board = testInit()

        let peg1 = Peg(center: CGPoint(x: 500, y: 500), color: .orange)
        board.addPeg(peg1)

        let peg2 = Peg(center: CGPoint(x: 200, y: 200), color: .blue)
        board.addPeg(peg2)

        XCTAssertEqual(board.pegs.count, 2)

        board.removeAllPegs()

        XCTAssert(board.pegs.isEmpty)
    }

    func testToAndFromManagedObject() {
        let boardPegs: Set<Peg> = [Peg(center: CGPoint(x: 200, y: 200), color: .orange),
                                   Peg(center: CGPoint(x: 400, y: 400), color: .orange),
                                   Peg(center: CGPoint(x: 600, y: 600), color: .blue)]

        let board = Board(id: UUID(),
                          name: "My Test Board",
                          size: CGSize(width: 800, height: 800),
                          snapshot: nil,
                          pegs: boardPegs,
                          dateCreated: Date())

        let other = Board.fromManagedObject(board.toManagedObject())

        XCTAssertEqual(board, other)
    }
}
