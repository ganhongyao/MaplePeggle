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

    public func move(to newCenter: CGPoint) {
        center = newCenter
    }

    public func move(offset: CGVector) {
        let newCenter = center + CGPoint(from: offset)

        move(to: newCenter)
    }

    public func scale(factor: CGFloat) {
        radius *= factor
    }

    public func contains(point: CGPoint) -> Bool {
        center.distance(to: point) <= radius
    }

    public func overlaps(with otherCircle: Circular) -> Bool {
        center.distance(to: otherCircle.center) <= radius + otherCircle.radius
    }

    public func overlaps(with polygon: Polygonal) -> Bool {
        polygon.overlaps(with: self)
    }

    public func getMinMaxProjectionsOntoAxis(axis: CGVector) -> (CGFloat, CGFloat) {
        let normalizedAxis = axis.normalized()

        let directionVector = normalizedAxis * radius

        let pointOnCircumference1 = center + CGPoint(from: directionVector)
        let pointOnCircumference2 = center - CGPoint(from: directionVector)

        let projection1 = pointOnCircumference1.projectOnto(axis: normalizedAxis)
        let projection2 = pointOnCircumference2.projectOnto(axis: normalizedAxis)

        let minProjection = min(projection1, projection2)
        let maxProjection = max(projection1, projection2)

        return (minProjection, maxProjection)
    }
}
