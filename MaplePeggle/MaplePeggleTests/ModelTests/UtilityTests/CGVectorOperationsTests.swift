//
//  CGVectorExtensionsTests.swift
//  MaplePeggleTests
//
//  Created by Hong Yao on 12/2/22.
//

import XCTest
@testable import MaplePeggle

class CGVectorOperationsTests: XCTestCase {

    func testScale_positiveFactor() {
        let vector = CGVector(dx: 5, dy: 9)

        XCTAssertEqual(vector.scale(by: 3), CGVector(dx: 15, dy: 27))
    }

    func testScale_negativeFactor() {
        let vector = CGVector(dx: 5, dy: -9)

        XCTAssertEqual(vector.scale(by: -3), CGVector(dx: -15, dy: 27))
    }

    func testScale_zeroFactor_returnsZeroVector() {
        let vector = CGVector(dx: 3, dy: 7)

        XCTAssertEqual(vector.scale(by: 0), CGVector.zero)
    }

    func testSubtract() {
        let vector1 = CGVector(dx: 7, dy: 8)
        let vector2 = CGVector(dx: 3, dy: 17)

        XCTAssertEqual(vector1.subtract(vector2), CGVector(dx: 4, dy: -9))
    }

    func testSubtract_subtractZero_noChange() {
        let vector = CGVector(dx: 3, dy: 7)

        XCTAssertEqual(vector.subtract(.zero), vector)
    }

    func testSubtract_subtractSelf_returnsZeroVector() {
        let vector = CGVector(dx: 3, dy: 7)

        XCTAssertEqual(vector.subtract(vector), CGVector.zero)
    }

}
