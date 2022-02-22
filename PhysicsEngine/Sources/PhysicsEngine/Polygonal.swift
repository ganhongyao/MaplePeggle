//
//  Polygonal.swift
//  
//
//  Created by Hong Yao on 21/2/22.
//

import CoreGraphics

public protocol Polygonal: Shape {
    var vertices: [CGPoint] { get set }

    var edges: [(CGPoint, CGPoint)] { get }

    var edgeVectors: [CGVector] { get }
}

extension Polygonal {
    public var minX: CGFloat {
        vertices.reduce(CGFloat.infinity, { min($0, $1.x) })
    }

    public var maxX: CGFloat {
        vertices.reduce(-CGFloat.infinity, { max($0, $1.x) })
    }

    public var minY: CGFloat {
        vertices.reduce(CGFloat.infinity, { min($0, $1.y) })
    }

    public var maxY: CGFloat {
        vertices.reduce(-CGFloat.infinity, { max($0, $1.y) })
    }
    
    public var edges: [(CGPoint, CGPoint)] {
        vertices.indices.map { idx in
            (vertices[idx], vertices[(idx + 1) % vertices.count])
        }
    }

    public var edgeVectors: [CGVector] {
        edges.map { pointA, pointB in
            CGVector(from: pointB.subtract(pointA))
        }
    }

    public var centroid: CGPoint {
        let x = vertices.reduce(0.0, { $0 + $1.x }) / Double(vertices.count)
        let y = vertices.reduce(0.0, { $0 + $1.y }) / Double(vertices.count)

        return CGPoint(x: x, y: y)
    }

    public func move(to newCentroid: CGPoint) {
        let xOffset = newCentroid.x - centroid.x
        let yOffset = newCentroid.y - centroid.y

        for idx in vertices.indices {
            let originalVertex = vertices[idx]

            vertices[idx] = CGPoint(x: originalVertex.x + xOffset, y: originalVertex.y + yOffset)
        }
    }

    public func scale(factor: CGFloat) {
        for idx in vertices.indices {
            let originalVertex = vertices[idx]
            let newX = centroid.x + (originalVertex.x - centroid.x) * factor
            let newY = centroid.y + (originalVertex.y - centroid.y) * factor

            vertices[idx] = CGPoint(x: newX, y: newY)
        }
    }

    public func overlaps(with circle: Circular) -> Bool {
        for edgeVector in edgeVectors {
            let axis = edgeVector.perpendicular()

            if !Self.isProjectionOverlapping(circle: circle, polygon: self, axis: axis) {
                return false
            }
        }

        guard let closestVertex = closestVertex(to: circle.center) else {
            return false
        }

        let axis = CGVector(from: closestVertex.subtract(circle.center))

        if !Self.isProjectionOverlapping(circle: circle, polygon: self, axis: axis) {
            return false
        }

        return true
    }

    public func overlaps(with otherPolygon: Polygonal) -> Bool {
        for edgeVector in (edgeVectors + otherPolygon.edgeVectors) {
            let axis = edgeVector.perpendicular()

            if !Self.isProjectionOverlapping(polygonA: self, polygonB: otherPolygon, axis: axis) {
                return false
            }
        }

        return true
    }

    private static func isProjectionOverlapping(polygonA: Polygonal, polygonB: Polygonal, axis: CGVector) -> Bool {
        let normalizedAxis = axis.normalized()

        var minProjectionA: CGFloat = .infinity
        var maxProjectionA: CGFloat = -.infinity

        polygonA.vertices.forEach { vertex in
            let projection = vertex.projectOnto(axis: normalizedAxis)
            minProjectionA = min(minProjectionA, projection)
            maxProjectionA = max(maxProjectionA, projection)
        }

        var minProjectionB: CGFloat = .infinity
        var maxProjectionB: CGFloat = -.infinity

        polygonB.vertices.forEach { vertex in
            let projection = vertex.projectOnto(axis: normalizedAxis)
            minProjectionB = min(minProjectionB, projection)
            maxProjectionB = max(maxProjectionB, projection)
        }

        let isOverlappingIntervals = minProjectionA < maxProjectionB && minProjectionB < maxProjectionA

        return isOverlappingIntervals
    }

    private static func isProjectionOverlapping(circle: Circular, polygon: Polygonal, axis: CGVector) -> Bool {
        let normalizedAxis = axis.normalized()

        let directionVector = normalizedAxis.scale(factor: circle.radius)

        let pointOnCircumference1 = circle.center.add(CGPoint(from: directionVector))
        let pointOnCircumference2 = circle.center.subtract(CGPoint(from: directionVector))

        let projection1 = pointOnCircumference1.projectOnto(axis: normalizedAxis)
        let projection2 = pointOnCircumference2.projectOnto(axis: normalizedAxis)

        let circleMinProjection = min(projection1, projection2)
        let circleMaxProjection = max(projection1, projection2)

        var polygonMinProjection: CGFloat = .infinity
        var polygonMaxProjection: CGFloat = -.infinity

        polygon.vertices.forEach { vertex in
            let projection = vertex.projectOnto(axis: normalizedAxis)
            polygonMinProjection = min(polygonMinProjection, projection)
            polygonMaxProjection = max(polygonMaxProjection, projection)
        }

        let isOverlappingIntervals = circleMinProjection < polygonMaxProjection &&
                                     polygonMinProjection < circleMaxProjection

        return isOverlappingIntervals
    }

    private func closestVertex(to point: CGPoint) -> CGPoint? {
        vertices.min { $0.distance(to: point) < $1.distance(to: point) }
    }
}
