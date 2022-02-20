//
//  PhysicsBodyTests.swift
//  
//
//  Created by Hong Yao on 12/2/22.
//

import XCTest

class PhysicsBodyTests: XCTestCase {

    func testApplyForce() {
        let body = PhysicsBodyImpl(force: CGVector(dx: 30, dy: -20))
        let force = CGVector(dx: -70, dy: 90)

        body.applyForce(force: force)

        XCTAssertEqual(body.force.dx, 30 + (-70))
        XCTAssertEqual(body.force.dy, -20 + 90)
    }

    func testUpdateVelocity_unitMass() {
        let body = PhysicsBodyImpl(velocity: .zero, force: CGVector(dx: 3, dy: 5), mass: 1)

        body.updateVelocity(deltaTime: 1)
        XCTAssertEqual(body.velocity.dx, 3)
        XCTAssertEqual(body.velocity.dy, 5)

        body.updateVelocity(deltaTime: 2)
        XCTAssertEqual(body.velocity.dx, 9)
        XCTAssertEqual(body.velocity.dy, 15)

        body.updateVelocity(deltaTime: 7)
        XCTAssertEqual(body.velocity.dx, 30)
        XCTAssertEqual(body.velocity.dy, 50)
    }

    func testUpdateVelocity_nonUnitMass() {
        let body = PhysicsBodyImpl(velocity: CGVector(dx: -10, dy: 20), force: CGVector(dx: 4, dy: 6), mass: 2)

        body.updateVelocity(deltaTime: 1)
        XCTAssertEqual(body.velocity.dx, -8)
        XCTAssertEqual(body.velocity.dy, 23)

        body.updateVelocity(deltaTime: 2)
        XCTAssertEqual(body.velocity.dx, -4)
        XCTAssertEqual(body.velocity.dy, 29)

        body.updateVelocity(deltaTime: 7)
        XCTAssertEqual(body.velocity.dx, 10)
        XCTAssertEqual(body.velocity.dy, 50)
    }

    func testUpdateVelocity_nonUnitMass_negativeForces() {
        let body = PhysicsBodyImpl(velocity: CGVector(dx: 5, dy: -30), force: CGVector(dx: -4, dy: 9), mass: 2)

        body.updateVelocity(deltaTime: 1)
        XCTAssertEqual(body.velocity.dx, 3)
        XCTAssertEqual(body.velocity.dy, -25.5)

        body.updateVelocity(deltaTime: 2)
        XCTAssertEqual(body.velocity.dx, -1)
        XCTAssertEqual(body.velocity.dy, -16.5)

        body.updateVelocity(deltaTime: 7)
        XCTAssertEqual(body.velocity.dx, -15)
        XCTAssertEqual(body.velocity.dy, 15)
    }

    func testUpdateCenter_movable() {
        let body = PhysicsBodyImpl(isMovable: true, velocity: CGVector(dx: 1, dy: 2), center: .zero)

        body.updateCenter(deltaTime: 1)
        XCTAssertEqual(body.center.x, 1)
        XCTAssertEqual(body.center.y, 2)

        body.updateCenter(deltaTime: 2)
        XCTAssertEqual(body.center.x, 3)
        XCTAssertEqual(body.center.y, 6)

        body.updateCenter(deltaTime: 7)
        XCTAssertEqual(body.center.x, 10)
        XCTAssertEqual(body.center.y, 20)
    }

    func testUpdateCenter_movable_negativeVelocities() {
        let body = PhysicsBodyImpl(isMovable: true, velocity: CGVector(dx: -3, dy: -2), center: CGPoint(x: 15, y: 35))

        body.updateCenter(deltaTime: 1)
        XCTAssertEqual(body.center.x, 12)
        XCTAssertEqual(body.center.y, 33)

        body.updateCenter(deltaTime: 2)
        XCTAssertEqual(body.center.x, 6)
        XCTAssertEqual(body.center.y, 29)

        body.updateCenter(deltaTime: 7)
        XCTAssertEqual(body.center.x, -15)
        XCTAssertEqual(body.center.y, 15)
    }

    func testUpdateCenter_immovable_nothingHappens() {
        let body = PhysicsBodyImpl(isMovable: false, velocity: CGVector(dx: 1, dy: 2), center: .zero)

        body.updateCenter(deltaTime: 1)
        XCTAssertEqual(body.center, CGPoint.zero)

        body.updateCenter(deltaTime: 2)
        XCTAssertEqual(body.center, CGPoint.zero)

        body.updateCenter(deltaTime: 7)
        XCTAssertEqual(body.center, CGPoint.zero)
    }

}
