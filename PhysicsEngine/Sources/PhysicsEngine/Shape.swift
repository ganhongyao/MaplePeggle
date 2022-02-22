//
//  Shape.swift
//  
//
//  Created by Hong Yao on 21/2/22.
//

import CoreGraphics

public protocol Shape: AnyObject {
    func scale(factor: CGFloat)

    func overlaps(with shape: Shape) -> Bool

    func overlaps(with circle: Circular) -> Bool

    func overlaps(with polygon: Polygonal) -> Bool

    func getMinMaxProjectionsOntoAxis(axis: CGVector) -> (CGFloat, CGFloat)
}

extension Shape {
    public func overlaps(with shape: Shape) -> Bool {
        switch shape {
        case let circle as Circular:
            return overlaps(with: circle)
        case let polygon as Polygonal:
            return overlaps(with: polygon)
        default:
            assertionFailure("Unknown shape")
            return false
        }
    }
}
