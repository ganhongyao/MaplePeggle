//
//  GameCannon.swift
//  PeggleClone
//
//  Created by Hong Yao on 6/2/22.
//

import CoreGraphics

class GameCannon {
    private static let defaultHeight = 100.0

    private static let maxRotationAngle = CGFloat.pi / 2

    private static let ballLaunchVelocity: CGFloat = 1_000

    var height = defaultHeight

    private var lastValidAimedLocation: CGPoint

    private var aimedLocation: CGPoint

    /// The x-coordinate of the cannon is fixed, but the y-coordinate depends on the height of the cannon
    private var xCoordinate: CGFloat

    var center: CGPoint {
        CGPoint(x: xCoordinate, y: height / 2)
    }

    private var ballStartingPosition: CGPoint {
        center
    }

    private var ballLaunchDirectionVector: CGVector {
        computeBallLaunchDirectionVector(referencePoint: lastValidAimedLocation)
    }

    var rotationAngle: CGFloat {
        computeRotationAngle(referencePoint: lastValidAimedLocation)
    }

    var isAimingAtSelf: Bool {
        let cannonRect = CGRect(x: center.x - height / 2,
                                y: center.y - height / 2,
                                width: height, height: height)

        return cannonRect.contains(aimedLocation)
    }

    var ballToLaunch: GameBall {
        let ball = GameBall(center: center)

        let scaleFactor = GameCannon.ballLaunchVelocity / ballLaunchDirectionVector.norm

        ball.velocity = ballLaunchDirectionVector.scale(by: scaleFactor)

        return ball
    }

    init(xCoordinate: CGFloat, initialAimedLocation: CGPoint) {
        self.xCoordinate = xCoordinate
        aimedLocation = initialAimedLocation
        lastValidAimedLocation = aimedLocation
    }

    @discardableResult func aim(towards aimedLocation: CGPoint) -> Bool {
        self.aimedLocation = aimedLocation

        let willExceedMaxRotation = abs(computeRotationAngle(referencePoint: aimedLocation)) >
                                    GameCannon.maxRotationAngle

        guard !willExceedMaxRotation else {
            return false
        }

        lastValidAimedLocation = aimedLocation

        return true
    }

    private func computeRotationAngle(referencePoint: CGPoint) -> CGFloat {
        let launchDirectionVector = computeBallLaunchDirectionVector(referencePoint: referencePoint)
        return -atan2(launchDirectionVector.dx, launchDirectionVector.dy)
    }

    private func computeBallLaunchDirectionVector(referencePoint: CGPoint) -> CGVector {
        CGVector(from: referencePoint).subtract(CGVector(from: ballStartingPosition))
    }
}
