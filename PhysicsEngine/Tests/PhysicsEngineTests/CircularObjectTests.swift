//
//  CircularObjectTests.swift
//  PhysicsEngineTests
//
//  Created by Hong Yao on 29/1/22.
//

import XCTest

class CircularObjectTests: XCTestCase {

    func testContains_pointOutsideObject_returnsFalse() {
        let circle = CircularObjectImpl(center: .zero, radius: 1)

        let point1 = CGPoint(x: 0.9, y: 0.9)
        XCTAssertFalse(circle.contains(point: point1))

        let point2 = CGPoint(x: 1.01, y: 0)
        XCTAssertFalse(circle.contains(point: point2))

        let point3 = CGPoint(x: 0, y: 1.01)
        XCTAssertFalse(circle.contains(point: point3))
    }

    func testContains_pointInsideObject_returnsTrue() {
        let circle = CircularObjectImpl(center: .zero, radius: 1)

        let point1 = CGPoint(x: 0, y: 0)
        XCTAssertTrue(circle.contains(point: point1))

        let point2 = CGPoint(x: 0.5, y: 0.5)
        XCTAssertTrue(circle.contains(point: point2))

        let point3 = CGPoint(x: 0.9, y: 0.3)
        XCTAssertTrue(circle.contains(point: point3))
    }

    func testContains_pointOnCircumference_returnsTrue() {
        let circle = CircularObjectImpl(center: .zero, radius: 1)

        let point1 = CGPoint(x: 1, y: 0)
        XCTAssertTrue(circle.contains(point: point1))

        let point2 = CGPoint(x: 0, y: 1)
        XCTAssertTrue(circle.contains(point: point2))

        let point3 = CGPoint(x: 0, y: -1)
        XCTAssertTrue(circle.contains(point: point3))
    }

    func testContains_negativeRadius_returnsFalse() {
        let circle = CircularObjectImpl(center: .zero, radius: -100)

        let point = CGPoint.zero
        XCTAssertFalse(circle.contains(point: point))
    }

    func testOverlaps_noOverlap_returnsFalse() {
        let circleAtOrigin = CircularObjectImpl(center: .zero, radius: 1)
        let otherCircle = CircularObjectImpl(center: CGPoint(x: 10, y: 0), radius: 1)

        XCTAssertFalse(circleAtOrigin.overlaps(with: otherCircle))
        XCTAssertFalse(otherCircle.overlaps(with: circleAtOrigin))
    }

    func testOverlaps_overlap_returnsTrue() {
        let circle1 = CircularObjectImpl(center: CGPoint(x: 1, y: 1), radius: 5)
        let circle2 = CircularObjectImpl(center: CGPoint(x: 5, y: 5), radius: 4)

        XCTAssertTrue(circle1.overlaps(with: circle2))
        XCTAssertTrue(circle2.overlaps(with: circle1))
    }

    func testOverlaps_smallerCircleWithinLargerCircle_returnsTrue() {
        let smallCircle = CircularObjectImpl(center: .zero, radius: 1)
        let largeCircle = CircularObjectImpl(center: .zero, radius: 10)

        XCTAssertTrue(smallCircle.overlaps(with: largeCircle))
        XCTAssertTrue(largeCircle.overlaps(with: smallCircle))
    }

    func testOverlaps_touchOnCircumference_returnsTrue() {
        // Touches at (1, 0)
        let leftCircle = CircularObjectImpl(center: .zero, radius: 1)
        let rightCircle = CircularObjectImpl(center: CGPoint(x: 2, y: 0), radius: 1)

        XCTAssertTrue(rightCircle.overlaps(with: leftCircle))
        XCTAssertTrue(leftCircle.overlaps(with: rightCircle))
    }

}
