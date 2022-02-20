//
//  CGPoint+Distance.swift
//  PeggleClone
//
//  Created by Hong Yao on 18/1/22.
//

import CoreGraphics

extension CGPoint {
    func distance(to otherPoint: CGPoint) -> CGFloat {
        sqrt(
            pow(x - otherPoint.x, 2) +
            pow(y - otherPoint.y, 2)
        )
    }
}
