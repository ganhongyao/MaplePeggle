//
//  SpherePolygonCollision.swift
//  
//
//  Created by Hong Yao on 22/2/22.
//

import Foundation
import CoreGraphics

struct SpherePolygonCollision: Collision {
    private let circle: CircularPhysicsBody

    private let polygon: PolygonalPhysicsBody

    init?(circle: CircularPhysicsBody, polygon: PolygonalPhysicsBody) {
        guard circle.isMovable || polygon.isMovable else {
            return nil
        }

        self.circle = circle
        self.polygon = polygon

        circle.collisionCount += 1
        polygon.collisionCount += 1
    }

    func resolveCollision() {
        var normal: CGVector = .zero
        var depth: CGFloat = .infinity

        for edgeVector in polygon.edgeVectors {
            let axis = edgeVector.perpendicular()

            let (circleMinProjection, circleMaxProjection) = projectOnto(circle: circle, axis: axis)
            let (polygonMinProjection, polygonMaxProjection) = projectOnto(polygon: polygon, axis: axis)

            let axisDepth = min(polygonMaxProjection - circleMinProjection, circleMaxProjection - polygonMinProjection)
            if axisDepth < depth {
                depth = axisDepth
                normal = axis.normalized()
            }
        }

        guard let closestVertex = closestVertex(to: circle.center) else {
            return
        }

        let axis = CGVector(from: closestVertex.subtract(circle.center))
        let (circleMinProjection, circleMaxProjection) = projectOnto(circle: circle, axis: axis)
        let (polygonMinProjection, polygonMaxProjection) = projectOnto(polygon: polygon, axis: axis)

        let axisDepth = min(polygonMaxProjection - circleMinProjection, circleMaxProjection - polygonMinProjection)
        if axisDepth < depth {
            depth = axisDepth
            normal = axis.normalized()
        }

        let collisionAngle = -atan2(normal.dy, normal.dx)

        let initialRotatedVelocity = circle.velocity.rotate(by: collisionAngle)
        let finalRotatedVelocity = CGVector(dx: -initialRotatedVelocity.dx,
                                         dy: initialRotatedVelocity.dy)
        let finalVelocity = finalRotatedVelocity.rotate(by: -collisionAngle)
        circle.velocity = finalVelocity

        let timeToMoveOut = depth / circle.velocity.norm
        circle.updateCenter(deltaTime: timeToMoveOut)

        return
    }

    func projectOnto(circle: Circular, axis: CGVector) -> (CGFloat, CGFloat) {
        let normalizedAxis = axis.normalized()

        let directionVector = normalizedAxis.scale(factor: circle.radius)

        let pointOnCircumference1 = circle.center.add(CGPoint(from: directionVector))
        let pointOnCircumference2 = circle.center.subtract(CGPoint(from: directionVector))

        let projection1 = pointOnCircumference1.projectOnto(axis: normalizedAxis)
        let projection2 = pointOnCircumference2.projectOnto(axis: normalizedAxis)

        let minProjection = min(projection1, projection2)
        let maxProjection = max(projection1, projection2)

        return (minProjection, maxProjection)
    }

    func projectOnto(polygon: Polygonal, axis: CGVector) -> (CGFloat, CGFloat) {
        let normalizedAxis = axis.normalized()

        var minProjection: CGFloat = .infinity
        var maxProjection: CGFloat = -.infinity

        polygon.vertices.forEach { vertex in
            let projection = vertex.projectOnto(axis: normalizedAxis)
            minProjection = min(minProjection, projection)
            maxProjection = max(maxProjection, projection)
        }

        return (minProjection, maxProjection)
    }

    func isProjectionOverlapping(circle: Circular, polygon: Polygonal, axis: CGVector) -> Bool {
        let (circleMinProjection, circleMaxProjection) = projectOnto(circle: circle, axis: axis)

        let (polygonMinProjection, polygonMaxProjection) = projectOnto(polygon: polygon, axis: axis)

        let isOverlappingIntervals = circleMinProjection < polygonMaxProjection &&
                                     polygonMinProjection < circleMaxProjection

        return isOverlappingIntervals
    }

    private func closestVertex(to point: CGPoint) -> CGPoint? {
        polygon.vertices.min { $0.distance(to: point) < $1.distance(to: point) }
    }
}
