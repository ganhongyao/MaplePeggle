//
//  GameBoardViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 4/2/22.
//

import Foundation
import CoreGraphics
import QuartzCore
import PhysicsEngine

class GameBoardViewModel: ObservableObject {
    @Published private var gameBoard: GameBoard

    private unowned var gameViewModel: GameViewModel

    private(set) var cannonViewModel: GameCannonViewModel

    private var displayLink: CADisplayLink?

    private var hasGameStarted: Bool {
        displayLink != nil
    }

    var gamePegs: [GamePeg] {
        gameBoard.gamePegs
    }

    var gameBlocks: [GameBlock] {
        gameBoard.gameBlocks
    }

    var gameBall: GameBall? {
        gameBoard.gameBall
    }

    var hasBallWithinBoard: Bool {
        gameBoard.hasBallWithinBoard
    }

    var boardSize: CGSize {
        gameBoard.size
    }

    var shouldLaunchBall: Bool {
        gameBoard.shouldLaunchBall
    }

    init(board: Board, gameViewModel: GameViewModel) {
        let gameBoard = GameBoard(from: board)
        self.gameBoard = gameBoard
        self.gameViewModel = gameViewModel
        cannonViewModel = GameCannonViewModel(gameCannon: gameBoard.gameCannon)
    }

    func initialiseDisplayLink() {
        guard displayLink == nil else {
            return
        }

        let link = CADisplayLink(target: self, selector: #selector(step))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    func deinitialiseDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func step(displayLink: CADisplayLink) {
        let deltaTime = displayLink.targetTimestamp - displayLink.timestamp

        let collisions = gameBoard.simulate(deltaTime: deltaTime)

        collisions.forEach { $0.resolveCollision() }

        gameBoard.activatePowerups(gameMaster: gameViewModel.chosenGameMaster)

        gameBoard.applyPowerups()

        gameBoard.handleBallLeftBoard()

        gameBoard.removeBoardObjectsExceedingMaxCollisions()

        if gamePegs.isEmpty {
            gameViewModel.isShowingDialog = true
        }

        objectWillChange.send()
    }

    func setCannonHeight(_ height: CGFloat) {
        cannonViewModel.cannonHeight = height

        gameBoard.size.height += height

        gameBoard.offsetPegsByCannonHeight()
        gameBoard.offsetBlocksByCannonHeight()

        objectWillChange.send()
    }

    func setBucketHeight(_ height: CGFloat) {
        gameBoard.size.height += height
    }

    func launchBall() {
        guard hasGameStarted else {
            return
        }

        gameBoard.launchBall()

        objectWillChange.send()
    }

    func aimCannon(towards aimedLocation: CGPoint) {
        cannonViewModel.aim(towards: aimedLocation)
    }

    func restart() {
        gameBoard.resetToInitialState()
        gameViewModel.chosenGameMaster = nil
        objectWillChange.send()
    }
}
