//
//  Shape.swift
//  
//
//  Created by Hong Yao on 21/2/22.
//

import CoreGraphics

public protocol Shape {
    func contains(point: CGPoint) -> Bool

    func overlaps(with circle: Circular) -> Bool

    func overlaps(with triangle: Triangular) -> Bool
}
