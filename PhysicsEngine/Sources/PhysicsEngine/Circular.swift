//
//  Circular.swift
//
//
//  Created by Hong Yao on 4/2/22.
//

import CoreGraphics

public protocol Circular: Shape {
    var center: CGPoint { get set }

    var radius: CGFloat { get set }
}

extension Circular {
    public var diameter: CGFloat {
        radius * 2
    }

    public func contains(point: CGPoint) -> Bool {
        center.distance(to: point) <= radius
    }

    public func overlaps(with otherCircle: Circular) -> Bool {
        center.distance(to: otherCircle.center) <= radius + otherCircle.radius
    }

    public func overlaps(with triangle: Triangular) -> Bool {
        false
    }
}
