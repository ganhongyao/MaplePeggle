//
//  GameBoard.swift
//  MaplePeggle
//
//  Created by Hong Yao on 4/2/22.
//

import Foundation
import CoreGraphics
import PhysicsEngine

class GameBoard: Board, PhysicsWorld {
    private static let maxCollisionsBeforeForceRemoval = 50

    private static let numInitialBalls = 10

    var physicsBodies: [PhysicsBody] = []

    let passableBoundaries: Set<PhysicsWorldBoundary> = [.bottom]

    var gravity = CGVector(dx: 0, dy: 500)

    var currentScore: Int = 0

    var gameCannon: GameCannon

    var gameBucket: GameBucket

    var gamePegs: [GamePeg] {
        physicsBodies.compactMap({ $0 as? GamePeg })
    }

    var gameBlocks: [GameBlock] {
        physicsBodies.compactMap({ $0 as? GameBlock })
    }

    var gameBall: GameBall? {
        physicsBodies.compactMap({ $0 as? GameBall }).first
    }

    /// Pegs that are to be removed in the next re-render.
    var pegsToBeRemovedQueue: [GamePeg] = []

    var gameEffects: [GameEffect] = []

    var numBallsRemaining = GameBoard.numInitialBalls

    var hasBallWithinBoard: Bool {
        guard let gameBall = gameBall else {
            return false
        }

        return gameBall.center.y - gameBall.radius <= size.height
    }

    var shouldLaunchBall: Bool {
        !gameCannon.isAimingAtSelf && gameBall == nil && numBallsRemaining > 0
    }

    required init(name: String, baseSize: CGSize, size: CGSize, snapshot: Data?, pegs: Set<Peg>, blocks: Set<Block>,
                  id: UUID?, dateCreated: Date? = Date(), isSeedData: Bool = false) {
        let boardCenter = CGPoint(x: size.width / 2, y: size.height / 2)
        gameCannon = GameCannon(xCoordinate: boardCenter.x, initialAimedLocation: boardCenter)
        gameBucket = GameBucket(initialPosition: CGPoint(x: boardCenter.x, y: size.height))

        super.init(name: name, baseSize: baseSize, size: size, snapshot: snapshot, pegs: pegs, blocks: blocks, id: id,
                   dateCreated: dateCreated, isSeedData: isSeedData)

        addBody(physicsBody: gameBucket)

        addGamePegsFromPegs()
        addGameBlocksFromBlocks()
    }

    convenience init(from board: Board) {
        self.init(name: board.name, baseSize: board.baseSize, size: board.size, snapshot: board.snapshot,
                  pegs: board.pegs, blocks: board.blocks, id: board.id, dateCreated: board.dateCreated,
                  isSeedData: board.isSeedData)
    }

    private func addGamePegsFromPegs() {
        let gamePegs = pegs.map(GamePeg.init)
        gamePegs.forEach { addBody(physicsBody: $0) }
    }

    private func addGameBlocksFromBlocks() {
        let gameBlocks = blocks.map(GameBlock.init)
        gameBlocks.forEach { addBody(physicsBody: $0) }
    }

    func launchBall() {
        guard shouldLaunchBall else {
            return
        }

        let ball = gameCannon.ballToLaunch

        addBody(physicsBody: ball)

        numBallsRemaining -= 1
    }

    func handleBallLeftBoard() {
        guard !hasBallWithinBoard else {
            return
        }

        removeBall()
        removeCollidedPegs()
    }

    func handleBallEnteredBucket() {
        removeBall()

        numBallsRemaining += 1
    }

    func handleCollision(collision: Collision) {
        if CollisionProfiler.isBallEnteringBucket(collision: collision) {
            handleBallEnteredBucket()
            return
        }

        if let litPeg = CollisionProfiler.getLitPeg(collision: collision) {
            handleScoringForLitPeg(litPeg: litPeg)
        }

        collision.resolveCollision()
    }

    func handleScoringForLitPeg(litPeg: GamePeg) {
        gameBall?.numPegsHit += 1
        gameBall?.subtotalScore += GameScoreCalculator.calculateScoreForHittingPeg(gameBoard: self, gamePeg: litPeg)
    }

    func activatePowerups(gameMaster: GameMaster?) {
        guard let gameMaster = gameMaster else {
            return
        }

        for powerupPeg in gamePegs.filter({ $0.willActivatePowerup }) {
            switch gameMaster.powerup {
            case .kaboom:
                gameEffects.append(CircularExplosionPowerup(from: powerupPeg))
            case .spookyBall:
                gameEffects.append(SpookyBallPowerup())
            case .bucketExpansion:
                gameEffects.append(BucketExpansionPowerup())
            case .crossZapper:
                gameEffects.append(CrossZapperPowerup(from: powerupPeg))
            }

            powerupPeg.hasActivatedPowerup = true
        }
    }

    func applyPowerups() {
        for powerup in gameEffects {
            let wasApplied = powerup.apply(gameBoard: self)
            if wasApplied {
                gameEffects.removeAll { $0 === powerup }
            }
        }
    }

    func removeGamePegsQueuedForRemoval() {
        pegsToBeRemovedQueue.forEach { removeGamePeg(gamePeg: $0) }
        pegsToBeRemovedQueue = []
    }

    func removeGamePeg(gamePeg: GamePeg) {
        physicsBodies.removeAll { $0 === gamePeg }
    }

    func removeBoardObjectsExceedingMaxCollisions() {
        removePegsExceedingMaxCollisions()
        removeBlocksExceedingMaxCollisions()
    }

    func removePegsExceedingMaxCollisions() {
        physicsBodies.removeAll {
            $0 is GamePeg && $0.collisionCount > GamePeg.maxCollisionsBeforeForceRemoval
        }
    }

    func removeBlocksExceedingMaxCollisions() {
        physicsBodies.removeAll {
            $0 is GameBlock && $0.collisionCount > GameBlock.maxCollisionsBeforeForceRemoval
        }
    }

    func offsetPegsByCannonHeight() {
        gamePegs.forEach { $0.center.y += gameCannon.height }
    }

    func offsetBlocksByCannonHeight() {
        gameBlocks.forEach { $0.center.y += gameCannon.height }
    }

    func resetToInitialState() {
        currentScore = 0
        numBallsRemaining = GameBoard.numInitialBalls
        gameEffects = []
        physicsBodies = []

        gameBucket.centralize()
        addBody(physicsBody: gameBucket)

        addGamePegsFromPegs()
        addGameBlocksFromBlocks()

        offsetPegsByCannonHeight()
        offsetBlocksByCannonHeight()
    }

    private func removeBall() {
        currentScore += gameBall?.totalScore ?? 0

        physicsBodies = physicsBodies.filter({ $0 !== gameBall })
    }

    private func removeCollidedPegs() {
        physicsBodies = physicsBodies.filter({ !isCollidedPeg(physicsBody: $0) })
    }

    private func isCollidedPeg(physicsBody: PhysicsBody) -> Bool {
        guard let gamePeg = physicsBody as? GamePeg else {
            return false
        }

        return gamePeg.hasCollided
    }
}
