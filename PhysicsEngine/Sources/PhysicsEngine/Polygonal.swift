//
//  Polygonal.swift
//  
//
//  Created by Hong Yao on 21/2/22.
//

import CoreGraphics

public protocol Polygonal: Shape {
    var vertices: [CGPoint] { get }

    var edges: [(CGPoint, CGPoint)] { get }

    var edgeVectors: [CGVector] { get }
}

extension Polygonal {
    public func overlaps(otherPolygon: Polygonal) -> Bool {
        for edgeVector in (edgeVectors + otherPolygon.edgeVectors) {
            let axis = CGVector(dx: -edgeVector.dy, dy: edgeVector.dx)
            let normalizedAxis = axis.scale(factor: 1 / axis.norm)

            if !Self.isProjectionOverlapping(polygonA: self, polygonB: otherPolygon, axis: normalizedAxis) {
                return false
            }
        }

        return true
    }

    private static func isProjectionOverlapping(polygonA: Polygonal, polygonB: Polygonal, axis: CGVector) -> Bool {
        var minProjectionA: CGFloat = .infinity
        var maxProjectionA: CGFloat = -.infinity

        polygonA.vertices.forEach { vertex in
            let projection = vertex.projectOnto(axis: axis)
            minProjectionA = min(minProjectionA, projection)
            maxProjectionA = max(maxProjectionA, projection)
        }

        var minProjectionB: CGFloat = .infinity
        var maxProjectionB: CGFloat = -.infinity

        polygonB.vertices.forEach { vertex in
            let projection = vertex.projectOnto(axis: axis)
            minProjectionB = min(minProjectionB, projection)
            maxProjectionB = max(maxProjectionB, projection)
        }

        let isOverlappingIntervals = minProjectionA < maxProjectionB && minProjectionB < maxProjectionA

        return isOverlappingIntervals
    }
}
