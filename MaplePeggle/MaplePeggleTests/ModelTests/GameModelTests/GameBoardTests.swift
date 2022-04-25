//
//  GameBoardTests.swift
//  MaplePeggleTests
//
//  Created by Hong Yao on 13/2/22.
//

import XCTest
@testable import MaplePeggle

class GameBoardTests: XCTestCase {

    var gameBoard: GameBoard?

    override func setUp() {
        super.setUp()

        let board = Board(id: UUID(), name: "Test Board", size: CGSize(width: 500, height: 500), snapshot: nil,
                          pegs: [])

        board.addPeg(Peg(center: CGPoint(x: 100, y: 100), color: .orange))
        board.addPeg(Peg(center: CGPoint(x: 200, y: 200), color: .blue))
        board.addPeg(Peg(center: CGPoint(x: 300, y: 300), color: .orange))

        gameBoard = GameBoard(from: board)
    }

    func testLaunchBall() {
        guard let gameBoard = gameBoard else {
            XCTFail("Game board not initialised")
            return
        }

        XCTAssertNil(gameBoard.gameBall)

        gameBoard.launchBall()

        XCTAssertNotNil(gameBoard.gameBall)
    }

    func testLaunchBall_ballAlreadyOnBoard_nothingHappens() {
        guard let gameBoard = gameBoard else {
            XCTFail("Game board not initialised")
            return
        }

        // Launch first ball
        gameBoard.launchBall()
        XCTAssertNotNil(gameBoard.gameBall)
        XCTAssertEqual(gameBoard.physicsBodies.compactMap({ $0 as? GameBall }).count, 1)

        // Try to launch second ball
        gameBoard.launchBall()
        XCTAssertEqual(gameBoard.physicsBodies.compactMap({ $0 as? GameBall }).count, 1)
    }

    func testHandleBallLeftBoard_ballOutOfBoard_ballRemoved() {
        guard let gameBoard = gameBoard else {
            XCTFail("Game board not initialised")
            return
        }

        gameBoard.launchBall()

        guard let gameBall = gameBoard.gameBall else {
            XCTFail("Ball not in board")
            return
        }

        gameBall.center = CGPoint(x: gameBoard.size.width + 100, y: gameBoard.size.height + 100)

        gameBoard.handleBallLeftBoard()

        XCTAssertNil(gameBoard.gameBall)
    }

    func testHandleBallLeftBoard_ballOutOfBoard_collidedPegsRemoved() {
        guard let gameBoard = gameBoard else {
            XCTFail("Game board not initialised")
            return
        }

        gameBoard.launchBall()

        guard let gameBall = gameBoard.gameBall else {
            XCTFail("Ball not in board")
            return
        }

        gameBall.center = CGPoint(x: gameBoard.size.width + 100, y: gameBoard.size.height + 100)

        let gamePegs = [GamePeg](gameBoard.gamePegs)

        gamePegs[0].collisionCount = 1
        XCTAssert(gamePegs[0].hasCollided)

        gameBoard.handleBallLeftBoard()

        XCTAssertFalse(gameBoard.gamePegs.contains(gamePegs[0]))
        XCTAssert(gameBoard.gamePegs.contains(gamePegs[1]))
        XCTAssert(gameBoard.gamePegs.contains(gamePegs[2]))
    }

    func testHandleBallLeftBoard_ballStillInBoard_nothingHappens() {
        guard let gameBoard = gameBoard else {
            XCTFail("Game board not initialised")
            return
        }

        let originalPegsCount = gameBoard.gamePegs.count

        gameBoard.launchBall()

        let gamePegs = [GamePeg](gameBoard.gamePegs)

        while !gamePegs[0].hasExceededMaxCollisions {
            gamePegs[0].collisionCount += 1
        }

        gameBoard.handleBallLeftBoard()

        XCTAssertNotNil(gameBoard.gameBall)
        XCTAssertEqual(gameBoard.gamePegs.count, originalPegsCount)
    }

    func testRemovePegsWithMaxCollisions() {
        guard let gameBoard = gameBoard else {
            XCTFail("Game board not initialised")
            return
        }

        let gamePegs = [GamePeg](gameBoard.gamePegs)

        while !gamePegs[0].hasExceededMaxCollisions {
            gamePegs[0].collisionCount += 1
        }
        XCTAssert(gamePegs[0].hasExceededMaxCollisions)

        gameBoard.removeBoardObjectsExceedingMaxCollisions()

        XCTAssertFalse(gameBoard.gamePegs.contains(gamePegs[0]))
        XCTAssert(gameBoard.gamePegs.contains(gamePegs[1]))
        XCTAssert(gameBoard.gamePegs.contains(gamePegs[2]))
    }

}
