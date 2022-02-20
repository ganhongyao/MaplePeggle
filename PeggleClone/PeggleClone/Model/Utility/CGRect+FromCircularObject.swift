//
//  CGRect+FromCircularBoardObject.swift
//  PeggleClone
//
//  Created by Hong Yao on 29/1/22.
//

import CoreGraphics
import PhysicsEngine

extension CGRect {
    init(from circle: CircularObject) {
        let objectCenter = circle.center
        let objectRadius = circle.radius

        // Origin is located in the lower-left corner of the rectangle,
        // following the default Core Graphics coordinate space
        let origin = CGPoint(x: objectCenter.x - objectRadius, y: objectCenter.y - objectRadius)

        let objectDiameter = circle.diameter
        let size = CGSize(width: objectDiameter, height: objectDiameter)

        self.init(origin: origin, size: size)
    }
}
