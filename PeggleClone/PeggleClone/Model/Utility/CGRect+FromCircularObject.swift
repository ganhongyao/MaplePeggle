//
//  CGRect+FromCircularBoardObject.swift
//  PeggleClone
//
//  Created by Hong Yao on 29/1/22.
//

import CoreGraphics
import PhysicsEngine

extension CGRect {
    init(from object: BoardObject) {
        switch object {
        case let circle as Circular:
            self.init(from: circle)
        case let polygon as Polygonal:
            self.init(from: polygon)
        default:
            assertionFailure("BoardObject has unknown shape")
            self.init()
        }
    }

    init(from circle: Circular) {
        let objectCenter = circle.center
        let objectRadius = circle.radius

        // Origin is located in the lower-left corner of the rectangle,
        // following the default Core Graphics coordinate space
        let origin = CGPoint(x: objectCenter.x - objectRadius, y: objectCenter.y - objectRadius)

        let objectDiameter = circle.diameter
        let size = CGSize(width: objectDiameter, height: objectDiameter)

        self.init(origin: origin, size: size)
    }

    init(from polygon: Polygonal) {
        let minX = polygon.vertices.reduce(CGFloat.infinity, { min($0, $1.x) })
        let maxX = polygon.vertices.reduce(-CGFloat.infinity, { max($0, $1.x) })

        let minY = polygon.vertices.reduce(CGFloat.infinity, { min($0, $1.y) })
        let maxY = polygon.vertices.reduce(-CGFloat.infinity, { max($0, $1.y) })

        self.init(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}
