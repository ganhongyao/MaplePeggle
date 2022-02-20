//
//  CircularObject.swift
//
//
//  Created by Hong Yao on 4/2/22.
//

import CoreGraphics

public protocol CircularObject {
    var center: CGPoint { get set }

    var radius: CGFloat { get set }
}

extension CircularObject {
    public var diameter: CGFloat {
        radius * 2
    }

    public func contains(point: CGPoint) -> Bool {
        center.distance(to: point) <= radius
    }

    public func overlaps(with otherCircle: CircularObject) -> Bool {
        center.distance(to: otherCircle.center) <= radius + otherCircle.radius
    }
}
