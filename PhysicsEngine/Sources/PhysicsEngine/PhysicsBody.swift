//
//  PhysicsBody.swift
//  PhysicsEngine
//
//  Created by Hong Yao on 18/1/22.
//

import CoreGraphics

public protocol PhysicsBody: AnyObject {
    var isMovable: Bool { get }

    var center: CGPoint { get set }

    var velocity: CGVector { get set }

    var force: CGVector { get set }

    var mass: CGFloat { get set }

    var acceleration: CGVector { get }

    var bounciness: CGFloat { get set }

    var collisionCount: Int { get set }

    var hasCollided: Bool { get }

    func applyForce(force: CGVector)

    func updateVelocity(deltaTime: CFTimeInterval)

    func updateCenter(deltaTime: CFTimeInterval)

    func overlaps(with otherPhysicsBody: PhysicsBody) -> Bool

    func overlaps(with otherCircularPhysicsBody: CircularPhysicsBody) -> Bool

    func hasExceededBoundary(dimensions: CGSize, boundary: PhysicsWorldBoundary) -> Bool

    func moveWithinBoundary(dimensions: CGSize, boundary: PhysicsWorldBoundary)
}

extension PhysicsBody {
    public var acceleration: CGVector {
        CGVector(dx: force.dx / mass,
                 dy: force.dy / mass)
    }

    public var hasCollided: Bool {
        collisionCount > 0
    }

    public func applyForce(force: CGVector) {
        self.force.dx += force.dx
        self.force.dy += force.dy
    }

    public func updateVelocity(deltaTime: CFTimeInterval) {
        velocity.dx += acceleration.dx * deltaTime
        velocity.dy += acceleration.dy * deltaTime
    }

    public func updateCenter(deltaTime: CFTimeInterval) {
        guard isMovable else {
            return
        }

        center.x += velocity.dx * deltaTime
        center.y += velocity.dy * deltaTime
    }

    public func overlaps(with otherPhysicsBody: PhysicsBody) -> Bool {
        switch otherPhysicsBody {
        case let circularPhysicsBody as CircularPhysicsBody:
            return overlaps(with: circularPhysicsBody)
        default:
            assertionFailure("Unknown subclass of PhysicsBody")
            return false
        }
    }
}
