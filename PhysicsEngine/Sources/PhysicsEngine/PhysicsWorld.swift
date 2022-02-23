//
//  PhysicsWorld.swift
//  
//
//  Created by Hong Yao on 4/2/22.
//

import CoreGraphics

public protocol PhysicsWorld: AnyObject {
    var physicsBodies: [PhysicsBody] { get set }

    var size: CGSize { get set }

    var passableBoundaries: Set<PhysicsWorldBoundary> { get }

    var gravity: CGVector { get set }

    func simulate(deltaTime: CFTimeInterval) -> [Collision]

    func addBody(physicsBody: PhysicsBody)
}

/// Exposed method implementations
extension PhysicsWorld {
    public func simulate(deltaTime: CFTimeInterval) -> [Collision] {
        updateVelocities(deltaTime: deltaTime)
        updatePositions(deltaTime: deltaTime)
        keepBodiesWithinBoundaries()

        return findCollisions()
    }

    public func addBody(physicsBody: PhysicsBody) {
        let weight = gravity.scale(factor: physicsBody.mass)
        physicsBody.applyForce(force: weight)

        physicsBodies.append(physicsBody)
    }
}

/// Internal method implementations
extension PhysicsWorld {
    var unpassableBoundaries: Set<PhysicsWorldBoundary> {
        Set(PhysicsWorldBoundary.allCases).subtracting(passableBoundaries)
    }

    func updateVelocities(deltaTime: CFTimeInterval) {
        physicsBodies.forEach({ $0.updateVelocity(deltaTime: deltaTime) })
    }

    func updatePositions(deltaTime: CFTimeInterval) {
        physicsBodies.forEach({ $0.updateCenter(deltaTime: deltaTime) })
    }

    func findCollisions() -> [Collision] {
        var collisions: [Collision] = []

        for (i, bodyA) in physicsBodies.enumerated() {
            for bodyB in physicsBodies[(i + 1)...] {
                guard let collision = checkCollision(bodyA: bodyA, bodyB: bodyB) else {
                    continue
                }

                collisions.append(collision)
            }
        }

        return collisions
    }

    func checkCollision(bodyA: PhysicsBody, bodyB: PhysicsBody) -> Collision? {
        guard bodyA.overlaps(with: bodyB) else {
            return nil
        }

        switch (bodyA, bodyB) {
        case let (circleA, circleB) as (CircularPhysicsBody, CircularPhysicsBody):
            return SphereSphereCollision(bodyA: circleA, bodyB: circleB)
        case let (circle, polygon) as (CircularPhysicsBody, PolygonalPhysicsBody),
             let (polygon, circle) as (PolygonalPhysicsBody, CircularPhysicsBody):
            return SpherePolygonCollision(circle: circle, polygon: polygon)
        default:
            return nil
        }
    }

    func keepBodiesWithinBoundaries() {
        physicsBodies.forEach(keepBodyWithinBoundaries)
    }

    func keepBodyWithinBoundaries(body: PhysicsBody) {
        for boundary in unpassableBoundaries {
            guard body.hasExceededBoundary(dimensions: size, boundary: boundary) else {
                continue
            }

            body.moveWithinBoundary(dimensions: size, boundary: boundary)

            switch boundary {
            case .top, .bottom:
                let isSelfCorrecting = boundary == .top ? body.velocity.dy >= 0 : body.velocity.dy < 0
                guard !isSelfCorrecting else {
                    continue
                }

                body.velocity.dy *= -body.bounciness
            case .left, .right:
                let isSelfCorrecting = boundary == .left ? body.velocity.dx >= 0 : body.velocity.dx < 0
                guard !isSelfCorrecting else {
                    continue
                }

                body.velocity.dx *= -body.bounciness
            }
        }
    }
}
