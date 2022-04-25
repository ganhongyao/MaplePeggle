//
//  CGRect+FromBoardObject.swift
//  MaplePeggle
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
            assertionFailure("Initializer for shape not implemented")
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
        self.init(x: polygon.minX, y: polygon.minY,
                  width: polygon.maxX - polygon.minX,
                  height: polygon.maxY - polygon.minY)
    }
}
