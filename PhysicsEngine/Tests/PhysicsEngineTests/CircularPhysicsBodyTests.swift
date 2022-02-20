//
//  CircularPhysicsBodyTests.swift
//  
//
//  Created by Hong Yao on 12/2/22.
//

import XCTest

class CircularPhysicsBodyTests: XCTestCase {

    func testHasExceededBoundary_withinAllBoundaries_returnsFalse() {
        let dimensions = CGSize(width: 100, height: 100)

        let body = CircularPhysicsBodyImpl(center: CGPoint(x: 50, y: 50), radius: 10)

        XCTAssertFalse(body.hasExceededBoundary(dimensions: dimensions, boundary: .top))
        XCTAssertFalse(body.hasExceededBoundary(dimensions: dimensions, boundary: .bottom))
        XCTAssertFalse(body.hasExceededBoundary(dimensions: dimensions, boundary: .left))
        XCTAssertFalse(body.hasExceededBoundary(dimensions: dimensions, boundary: .right))
    }

    func testHasExceededBoundary_exceededTopBoundary_returnsTrue() {
        let dimensions = CGSize(width: 100, height: 100)

        let body = CircularPhysicsBodyImpl(center: CGPoint(x: 50, y: 5), radius: 10)

        XCTAssertTrue(body.hasExceededBoundary(dimensions: dimensions, boundary: .top))
    }

    func testHasExceededBoundary_touchesTopBoundary_returnsFalse() {
        let dimensions = CGSize(width: 100, height: 100)

        let body = CircularPhysicsBodyImpl(center: CGPoint(x: 50, y: 10), radius: 10)

        XCTAssertFalse(body.hasExceededBoundary(dimensions: dimensions, boundary: .top))
    }

    func testHasExceededBoundary_exceededBottomBoundary_returnsTrue() {
        let dimensions = CGSize(width: 100, height: 100)

        let body = CircularPhysicsBodyImpl(center: CGPoint(x: 50, y: 95), radius: 10)

        XCTAssertTrue(body.hasExceededBoundary(dimensions: dimensions, boundary: .bottom))
    }

    func testHasExceededBoundary_touchesBottomBoundary_returnsFalse() {
        let dimensions = CGSize(width: 100, height: 100)

        let body = CircularPhysicsBodyImpl(center: CGPoint(x: 50, y: 90), radius: 10)

        XCTAssertFalse(body.hasExceededBoundary(dimensions: dimensions, boundary: .bottom))
    }

    func testHasExceededBoundary_exceededLeftBoundary_returnsTrue() {
        let dimensions = CGSize(width: 100, height: 100)

        let body = CircularPhysicsBodyImpl(center: CGPoint(x: 5, y: 50), radius: 10)

        XCTAssertTrue(body.hasExceededBoundary(dimensions: dimensions, boundary: .left))
    }

    func testHasExceededBoundary_touchesLeftBoundary_returnsFalse() {
        let dimensions = CGSize(width: 100, height: 100)

        let body = CircularPhysicsBodyImpl(center: CGPoint(x: 10, y: 50), radius: 10)

        XCTAssertFalse(body.hasExceededBoundary(dimensions: dimensions, boundary: .left))
    }

    func testHasExceededBoundary_exceededRightBoundary_returnsTrue() {
        let dimensions = CGSize(width: 100, height: 100)

        let body = CircularPhysicsBodyImpl(center: CGPoint(x: 95, y: 50), radius: 10)

        XCTAssertTrue(body.hasExceededBoundary(dimensions: dimensions, boundary: .right))
    }

    func testHasExceededBoundary_touchesRightBoundary_returnsFalse() {
        let dimensions = CGSize(width: 100, height: 100)

        let body = CircularPhysicsBodyImpl(center: CGPoint(x: 90, y: 50), radius: 10)

        XCTAssertFalse(body.hasExceededBoundary(dimensions: dimensions, boundary: .right))
    }

}
