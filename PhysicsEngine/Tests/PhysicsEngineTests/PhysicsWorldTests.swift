//
//  PhysicsWorldTests.swift
//  
//
//  Created by Hong Yao on 12/2/22.
//

import XCTest
@testable import PhysicsEngine

class PhysicsWorldTests: XCTestCase {

    func testAddBody_weightApplied() {
        let world = PhysicsWorldImpl(gravity: CGVector(dx: 0, dy: 10))
        let body = PhysicsBodyImpl(force: CGVector(dx: 1, dy: 3), mass: 2.0)

        world.addBody(physicsBody: body)

        XCTAssertEqual(body.force, CGVector(dx: 1, dy: 23))
    }

    func testAddBody_negativeMass_negativeWeightApplied() {
        let world = PhysicsWorldImpl(gravity: CGVector(dx: 0, dy: 10))
        let body = PhysicsBodyImpl(force: CGVector(dx: 1, dy: 3), mass: -2.0)

        world.addBody(physicsBody: body)

        XCTAssertEqual(body.force, CGVector(dx: 1, dy: -17))
    }

    func testSimulate_velocityUpdated() {
        let body = CircularPhysicsBodyImpl(velocity: .zero, force: .zero, mass: 2)
        let world = PhysicsWorldImpl(physicsBodies: [], gravity: CGVector(dx: 0, dy: 10))

        world.addBody(physicsBody: body)
        XCTAssertEqual(body.force, CGVector(dx: 0, dy: 20))

        world.simulate(deltaTime: 1)

        XCTAssertEqual(body.velocity, CGVector(dx: 0, dy: 10))

        world.simulate(deltaTime: 0.5)

        XCTAssertEqual(body.velocity, CGVector(dx: 0, dy: 15))
    }

    func testSimulate_positionUpdated() {
        let body = CircularPhysicsBodyImpl(velocity: .zero, force: .zero, mass: 3, center: CGPoint(x: 50, y: 10))
        let world = PhysicsWorldImpl(physicsBodies: [], gravity: CGVector(dx: 0, dy: 10))

        world.addBody(physicsBody: body)
        XCTAssertEqual(body.force, CGVector(dx: 0, dy: 30))

        world.simulate(deltaTime: 1)

        XCTAssertEqual(body.velocity, CGVector(dx: 0, dy: 10))
        XCTAssertEqual(body.center, CGPoint(x: 50, y: 20))

        world.simulate(deltaTime: 0.5)

        XCTAssertEqual(body.velocity, CGVector(dx: 0, dy: 15))
        XCTAssertEqual(body.center, CGPoint(x: 50, y: 27.5))
    }

    func testSimulate_keptWithinBoundary() {
        let body = CircularPhysicsBodyImpl(velocity: CGVector(dx: 30, dy: 0), force: .zero, mass: 1,
                                           bounciness: 1, center: CGPoint(x: 80, y: 50))
        let world = PhysicsWorldImpl(physicsBodies: [], size: CGSize(width: 100, height: 100), gravity: .zero)

        world.addBody(physicsBody: body)

        world.simulate(deltaTime: 1)

        XCTAssertFalse(body.hasExceededBoundary(dimensions: world.size, boundary: PhysicsWorldBoundary.right))
        XCTAssertEqual(body.velocity.dx, -30)
    }

    func testSimulate_oenStationaryObject_collisionResolved() {
        let body1 = CircularPhysicsBodyImpl(isMovable: true, velocity: CGVector(dx: 10, dy: 0), force: .zero, mass: 1,
                                            bounciness: 0.8, center: CGPoint(x: 35, y: 50), radius: 10)
        let body2 = CircularPhysicsBodyImpl(isMovable: false, velocity: .zero, force: .zero, mass: 1,
                                            bounciness: 1, center: CGPoint(x: 70, y: 50), radius: 30)

        let world = PhysicsWorldImpl(physicsBodies: [], size: CGSize(width: 500, height: 100), gravity: .zero)

        world.addBody(physicsBody: body1)
        world.addBody(physicsBody: body2)

        world.simulate(deltaTime: 1)

        let isOnlyTouchingOnCircumference = body1.center.x + body1.radius == body2.center.x - body2.radius
        XCTAssertTrue(isOnlyTouchingOnCircumference)
        XCTAssertEqual(body1.velocity.dx, 10 * (-1) * body1.bounciness)
    }

    func testSimulate_twoMovingObjects_collisionResolved() {
        let body1 = CircularPhysicsBodyImpl(isMovable: true, velocity: CGVector(dx: 10, dy: 10), force: .zero,
                                            mass: 6, bounciness: 0.75, center: CGPoint(x: 10, y: 10), radius: 15)
        let body2 = CircularPhysicsBodyImpl(isMovable: true, velocity: CGVector(dx: -20, dy: -25), force: .zero,
                                            mass: 4, bounciness: 0.9, center: CGPoint(x: 65, y: 65), radius: 30)

        let world = PhysicsWorldImpl(physicsBodies: [], size: CGSize(width: 500, height: 500), gravity: .zero)

        world.addBody(physicsBody: body1)
        world.addBody(physicsBody: body2)

        world.simulate(deltaTime: 1)

        XCTAssertEqual(body1.velocity.dx, -13.963, accuracy: 0.01)
        XCTAssertEqual(body1.velocity.dy, -9.171, accuracy: 0.01)
        XCTAssertEqual(body2.velocity.dx, 15.268, accuracy: 0.01)
        XCTAssertEqual(body2.velocity.dy, 14.215, accuracy: 0.01)
    }
}
