//
//  Shape.swift
//  
//
//  Created by Hong Yao on 21/2/22.
//

import CoreGraphics

public protocol Shape: AnyObject {
    func contains(point: CGPoint) -> Bool

    func overlaps(with shape: Shape) -> Bool

    func overlaps(with circle: Circular) -> Bool

    func overlaps(with triangle: Triangular) -> Bool
}

extension Shape {
    public func overlaps(with shape: Shape) -> Bool {
        switch shape {
        case let circle as Circular:
            return overlaps(with: circle)
        case let triangle as Triangular:
            return overlaps(with: triangle)
        default:
            assertionFailure("Unknown shape")
            return false
        }
    }
}
