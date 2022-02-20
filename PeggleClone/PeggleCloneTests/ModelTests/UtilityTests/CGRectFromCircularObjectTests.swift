//
//  CGRect+FromCircularObjectTests.swift
//  PeggleCloneTests
//
//  Created by Hong Yao on 29/1/22.
//

import XCTest
@testable import PeggleClone

class CGRectFromCircularObjectTests: XCTestCase {

    func testInit() {
        let circle = DummyCircularObject()

        let rect = CGRect(from: circle)

        XCTAssertNotNil(rect)
        XCTAssertEqual(rect.origin, CGPoint(x: -1, y: -1))
        XCTAssertEqual(rect.size, CGSize(width: circle.diameter, height: circle.diameter))
    }

}
