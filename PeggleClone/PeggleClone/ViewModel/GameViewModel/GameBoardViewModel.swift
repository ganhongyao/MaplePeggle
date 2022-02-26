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

    private(set) var bucketViewModel: GameBucketViewModel

    var displayLink: CADisplayLink?

    var scaleFactor: CGFloat = 1.0

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

    var numBallsRemaining: Int {
        gameBoard.numBallsRemaining
    }

    func numPegsRemaining(color: Peg.Color) -> Int {
        gameBoard.gamePegs.filter { $0.color == color }.count
    }

    var hasWon: Bool {
        numPegsRemaining(color: .orange) == 0
    }

    var hasLost: Bool {
        numPegsRemaining(color: .orange) > 0 && numBallsRemaining == 0
    }

    var hasEnded: Bool {
        !hasBallWithinBoard && (hasWon || hasLost)
    }

    init(board: Board, gameViewModel: GameViewModel) {
        let gameBoard = GameBoard(from: board)
        self.gameBoard = gameBoard
        self.gameViewModel = gameViewModel
        cannonViewModel = GameCannonViewModel(gameCannon: gameBoard.gameCannon)
        bucketViewModel = GameBucketViewModel(gameBucket: gameBoard.gameBucket)
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

        gameBoard.removeGamePegsQueuedForRemoval()

        let collisions = gameBoard.simulate(deltaTime: deltaTime)

        for collision in collisions {
            if isBallEnteringBucket(collision: collision) {
                gameBoard.handleBallEnteredBucket()
                continue
            }

            collision.resolveCollision()
        }

        gameBoard.activatePowerups(gameMaster: gameViewModel.chosenGameMaster)

        gameBoard.applyPowerups()

        gameBoard.handleBallLeftBoard()

        gameBoard.removeBoardObjectsExceedingMaxCollisions()

        if hasEnded {
            handleGameEnded()
        }

        objectWillChange.send()
    }

    private func isBallEnteringBucket(collision: Collision) -> Bool {
        let (bodyA, bodyB) = collision.bodies

        let involvesBallAndBucket = (bodyA is GameBucket && bodyB is GameBall) ||
                                    (bodyB is GameBucket && bodyA is GameBall)

        guard involvesBallAndBucket else {
            return false
        }

        return collision.collisionAngle == -.pi / 2
    }

    func scaleBoard(isFirstRender: Bool = true) {
        if isFirstRender {
            gameBoard.size = CGSize(width: gameBoard.size.width * scaleFactor,
                                    height: gameBoard.size.height * scaleFactor)
        }

        for gameBlock in gameBlocks {
            let newCentroid = CGPoint(x: gameBlock.centroid.x * scaleFactor, y: gameBlock.centroid.y * scaleFactor)
            gameBlock.scale(factor: scaleFactor)
            gameBlock.move(to: newCentroid)
        }

        for gamePeg in gamePegs {
            let newCenter = CGPoint(x: gamePeg.center.x * scaleFactor, y: gamePeg.center.y * scaleFactor)
            gamePeg.scale(factor: scaleFactor)
            gamePeg.move(to: newCenter)
        }

        objectWillChange.send()
    }

    func setCannonHeight(_ height: CGFloat) {
        cannonViewModel.cannonHeight = height
        cannonViewModel.cannonPosition = CGPoint(x: gameBoard.size.width / 2,
                                                 y: height / 2)

        gameBoard.size.height += height

        gameBoard.offsetPegsByCannonHeight()
        gameBoard.offsetBlocksByCannonHeight()

        objectWillChange.send()
    }

    func setBucketHeight(_ height: CGFloat) {
        bucketViewModel.bucketHeight = height
        bucketViewModel.bucketPosition = CGPoint(x: gameBoard.size.width / 2,
                                                 y: gameBoard.size.height + height / 2)

        gameBoard.size.height += height

        objectWillChange.send()
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
        scaleBoard(isFirstRender: false)
        gameViewModel.chosenGameMaster = nil
        objectWillChange.send()
    }

    private func handleGameEnded() {
        guard hasEnded else {
            return
        }

        gameViewModel.currentGameState = hasWon ? .won : .lost
    }
}
