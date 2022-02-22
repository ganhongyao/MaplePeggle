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

    public func rotate(angle: CGFloat) {
        for idx in vertices.indices {
            let originalVertex = vertices[idx]
            vertices[idx] = rotatePoint(point: originalVertex, angle: angle, anchor: centroid)
        }
    }

    private func rotatePoint(point: CGPoint, angle: CGFloat, anchor: CGPoint) -> CGPoint {
        let anchoredPoint = point.subtract(anchor)

        let rotatedPoint = CGPoint(x: anchoredPoint.x * cos(angle) - anchoredPoint.y * sin(angle),
                                   y: anchoredPoint.x * sin(angle) + anchoredPoint.y * cos(angle))

        let unanchoredPoint = rotatedPoint.add(anchor)

        return unanchoredPoint
    }

    public func overlaps(with circle: Circular) -> Bool {
        var axes = edgeVectors.map { $0.perpendicular() }

        if let closestVertex = closestVertex(to: circle.center) {
            axes.append(CGVector(from: closestVertex.subtract(circle.center)))
        }

        return axes.allSatisfy { axis in
            MathUtil.isOverlapping(interval1: getMinMaxProjectionsOntoAxis(axis: axis),
                                   interval2: circle.getMinMaxProjectionsOntoAxis(axis: axis))
        }
    }

    public func overlaps(with otherPolygon: Polygonal) -> Bool {
        let axes = (edgeVectors + otherPolygon.edgeVectors).map { $0.perpendicular() }

        return axes.allSatisfy { axis in
            MathUtil.isOverlapping(interval1: getMinMaxProjectionsOntoAxis(axis: axis),
                                   interval2: otherPolygon.getMinMaxProjectionsOntoAxis(axis: axis))
        }
    }

    public func getMinMaxProjectionsOntoAxis(axis: CGVector) -> (CGFloat, CGFloat) {
        let normalizedAxis = axis.normalized()

        var minProjection: CGFloat = .infinity
        var maxProjection: CGFloat = -.infinity

        vertices.forEach { vertex in
            let projection = vertex.projectOnto(axis: normalizedAxis)
            minProjection = min(minProjection, projection)
            maxProjection = max(maxProjection, projection)
        }

        return (minProjection, maxProjection)
    }

    func closestVertex(to point: CGPoint) -> CGPoint? {
        vertices.min { $0.distance(to: point) < $1.distance(to: point) }
    }
}
