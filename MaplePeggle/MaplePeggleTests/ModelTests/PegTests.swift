//
//  PegTests.swift
//  MaplePeggleTests
//
//  Created by Hong Yao on 29/1/22.
//

import XCTest
@testable import MaplePeggle

class PegTests: XCTestCase {

    func testInit() {
        let uuid = UUID()
        let center = CGPoint.zero
        let radius: CGFloat = 1
        let color = Peg.Color.orange
        let parentBoard = Board(name: "Test Board", size: CGSize(width: 500, height: 500))

        let peg = Peg(id: uuid, center: center, radius: radius, color: color, parentBoard: parentBoard)

        XCTAssertNotNil(peg)
        XCTAssertEqual(peg.id, uuid)
        XCTAssertEqual(peg.center, center)
        XCTAssertEqual(peg.radius, radius)
        XCTAssertEqual(peg.color, color)
        XCTAssert(peg.parentBoard === parentBoard)
    }

    func testMove() {
        let peg = Peg(center: .zero, color: .orange)

        let newCenter = CGPoint(x: 32, y: 17)

        peg.move(to: newCenter)

        XCTAssertEqual(peg.center, newCenter)
    }

    func testEquals_fieldsAreEqual_returnsTrue() {
        let sharedBoard = Board(name: "Test Board", size: CGSize(width: 500, height: 500))
        let peg1 = Peg(id: UUID(), center: .zero, radius: 1, color: .orange, parentBoard: sharedBoard)
        let peg2 = Peg(id: peg1.id, center: peg1.center, radius: peg1.radius, color: peg1.color,
                       parentBoard: sharedBoard)

        XCTAssertEqual(peg1, peg2)
    }

    func testEquals_differentId_returnsFalse() {
        let sharedBoard = Board(name: "Test Board", size: CGSize(width: 500, height: 500))
        let peg1 = Peg(id: UUID(), center: .zero, radius: 1, color: .orange, parentBoard: sharedBoard)
        let peg2 = Peg(id: UUID(), center: peg1.center, radius: peg1.radius, color: peg1.color,
                       parentBoard: sharedBoard)

        XCTAssertNotEqual(peg1, peg2)
    }

    func testEquals_differentCenter_returnsFalse() {
        let sharedBoard = Board(name: "Test Board", size: CGSize(width: 500, height: 500))
        let peg1 = Peg(id: UUID(), center: .zero, radius: 1, color: .orange, parentBoard: sharedBoard)
        let peg2 = Peg(id: peg1.id, center: CGPoint(x: 5, y: 5), radius: peg1.radius, color: peg1.color,
                       parentBoard: sharedBoard)

        XCTAssertNotEqual(peg1, peg2)
    }

    func testEquals_differentRadius_returnsFalse() {
        let sharedBoard = Board(name: "Test Board", size: CGSize(width: 500, height: 500))
        let peg1 = Peg(id: UUID(), center: .zero, radius: 1, color: .orange, parentBoard: sharedBoard)
        let peg2 = Peg(id: peg1.id, center: peg1.center, radius: 2, color: peg1.color, parentBoard: sharedBoard)

        XCTAssertNotEqual(peg1, peg2)
    }

    func testEquals_differentParentBoard_returnsFalse() {
        let board1 = Board(name: "Test Board", size: CGSize(width: 500, height: 500))
        let peg1 = Peg(id: UUID(), center: .zero, radius: 1, color: .orange, parentBoard: board1)

        let board2 = Board(name: "Test Board", size: CGSize(width: 500, height: 500))
        let peg2 = Peg(id: UUID(), center: peg1.center, radius: peg1.radius, color: peg1.color, parentBoard: board2)

        XCTAssertNotEqual(peg1, peg2)
    }

    func testToAndFromManagedObject() {
        let peg = Peg(id: UUID(), center: CGPoint(x: 32, y: 17), radius: 32.17, color: .orange)

        XCTAssertEqual(peg, Peg.fromManagedObject(peg.toManagedObject()))
    }

}
