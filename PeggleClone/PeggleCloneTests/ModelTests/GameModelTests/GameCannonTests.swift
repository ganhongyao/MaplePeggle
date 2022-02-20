//
//  GameCannonTests.swift
//  PeggleCloneTests
//
//  Created by Hong Yao on 13/2/22.
//

import XCTest
@testable import PeggleClone

class GameCannonTests: XCTestCase {

    var parentGameBoard: GameBoard?

    var gameCannon: GameCannon?

    override func setUp() {
        super.setUp()

        let board = Board(id: UUID(), name: "Test Board", size: CGSize(width: 500, height: 500), snapshot: nil,
                          pegs: [])
        let gameBoard = GameBoard(from: board)
        parentGameBoard = gameBoard

        let boardCenter = CGPoint(x: board.size.width / 2, y: board.size.height / 2)
        gameCannon = GameCannon(xCoordinate: boardCenter.x, initialAimedLocation: boardCenter)
    }

    func testAim_withinMaxRotation_returnsTrue() {
        guard let gameCannon = gameCannon else {
            XCTFail("Game cannon not initialised")
            return
        }

        guard let gameBoard = parentGameBoard else {
            XCTFail("Game board not initialised")
            return
        }

        let validAimPosition = CGPoint(x: gameBoard.size.width / 2 + 1, y: gameBoard.size.height / 2 + 1)

        XCTAssertTrue(gameCannon.aim(towards: validAimPosition))
    }

    func testAim_exceedsMaxRotation_returnsFalse() {
        guard let gameCannon = gameCannon else {
            XCTFail("Game cannon not initialised")
            return
        }

        guard let gameBoard = parentGameBoard else {
            XCTFail("Game board not initialised")
            return
        }

        let invalidAimPosition = CGPoint(x: gameBoard.size.width / 2, y: -5)

        XCTAssertFalse(gameCannon.aim(towards: invalidAimPosition))
    }

}
