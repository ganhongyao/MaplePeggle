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

    public func scale(factor: CGFloat) {
        radius *= factor
    }

    public func contains(point: CGPoint) -> Bool {
        center.distance(to: point) <= radius
    }

    public func overlaps(with otherCircle: Circular) -> Bool {
        center.distance(to: otherCircle.center) <= radius + otherCircle.radius
    }

    public func overlaps(with triangle: Triangular) -> Bool {
        // Check if any vertex is within circle
        if triangle.vertices.contains(where: { contains(point: $0) }) {
            return true
        }

        // Check if any edge intersects the circle
        for (pointA, pointB) in triangle.edges {
            if contains(point: closestPointFromCenterToLineSegment(pointA: pointA, pointB: pointB)) {
                return true
            }
        }

        return false
    }

    private func closestPointFromCenterToLineSegment(pointA: CGPoint, pointB: CGPoint) -> CGPoint {
        let vectorA = CGVector(from: pointA)
        let vectorB = CGVector(from: pointB)

        let vectorAB = vectorB.subtract(vectorA)
        let vectorAC = CGVector(from: center).subtract(vectorA)

        var t = vectorAC.dotProduct(with: vectorAB) / vectorAB.dotProduct(with: vectorAB)

        t = min(t, 1.0)
        t = max(t, 0.0)

        return CGPoint(from: vectorA.add(vectorAB.scale(factor: t)))
    }
}
