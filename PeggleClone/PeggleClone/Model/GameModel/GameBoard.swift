//
//  GameBoard.swift
//  PeggleClone
//
//  Created by Hong Yao on 4/2/22.
//

import Foundation
import CoreGraphics
import PhysicsEngine

class GameBoard: Board, PhysicsWorld {
    private static let maxCollisionsBeforeForceRemoval = 50

    var physicsBodies: [PhysicsBody] = []

    let passableBoundaries: Set<PhysicsWorldBoundary> = [.bottom]

    var gravity = CGVector(dx: 0, dy: 500)

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

    var powerups: [Powerup] = []

    var hasBallWithinBoard: Bool {
        guard let gameBall = gameBall else {
            return false
        }

        return gameBall.center.y - gameBall.radius <= size.height
    }

    var shouldLaunchBall: Bool {
        !gameCannon.isAimingAtSelf && gameBall == nil
    }

    required init(id: UUID?, name: String, size: CGSize, snapshot: Data?, pegs: Set<Peg>, blocks: Set<Block>,
                  dateCreated: Date? = Date()) {
        let boardCenter = CGPoint(x: size.width / 2, y: size.height / 2)
        gameCannon = GameCannon(xCoordinate: boardCenter.x, initialAimedLocation: boardCenter)
        gameBucket = GameBucket(xCoordinate: boardCenter.x, minYCoordinate: size.height)

        super.init(id: id, name: name, size: size, snapshot: snapshot, pegs: pegs, blocks: blocks, dateCreated: dateCreated)

        addBody(physicsBody: gameBucket)

        let gamePegs = pegs.map(GamePeg.init)
        gamePegs.forEach { addBody(physicsBody: $0) }

        let gameBlocks = blocks.map(GameBlock.init)
        gameBlocks.forEach { addBody(physicsBody: $0) }
    }

    convenience init(from board: Board) {
        self.init(id: board.id, name: board.name, size: board.size, snapshot: board.snapshot, pegs: board.pegs,
                  blocks: board.blocks, dateCreated: board.dateCreated)
    }

    func launchBall() {
        guard shouldLaunchBall else {
            return
        }

        let ball = gameCannon.ballToLaunch

        addBody(physicsBody: ball)
    }

    func handleBallLeftBoard() {
        guard !hasBallWithinBoard else {
            return
        }

        removeBall()
        removeCollidedPegs()
    }

    func activatePowerups(gameMaster: GameMaster?) {
        guard let gameMaster = gameMaster else {
            return
        }

        for powerupPeg in gamePegs.filter({ $0.willActivatePowerup }) {
            switch gameMaster.powerup {
            case .kaboom:
                powerups.append(CircularExplosionPowerup(from: powerupPeg))
            case .spookyBall:
                powerups.append(SpookyBallPowerup())
            }

            powerupPeg.hasActivatedPowerup = true
        }
    }

    func applyPowerups() {
        for powerup in powerups {
            let wasApplied = powerup.apply(gameBoard: self)
            if wasApplied {
                powerups.removeAll { $0 === powerup }
            }
        }
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
        powerups = []
        physicsBodies = []

        let gamePegs = pegs.map(GamePeg.init)
        gamePegs.forEach { addBody(physicsBody: $0) }

        let gameBlocks = blocks.map(GameBlock.init)
        gameBlocks.forEach { addBody(physicsBody: $0) }

        addBody(physicsBody: gameBucket)

        offsetPegsByCannonHeight()
        offsetBlocksByCannonHeight()
    }

    private func removeBall() {
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
