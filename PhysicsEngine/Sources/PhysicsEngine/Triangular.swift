//
//  Triangular.swift
//  
//
//  Created by Hong Yao on 21/2/22.
//

import CoreGraphics

public protocol Triangular: Shape {
    var vertex1: CGPoint { get set }

    var vertex2: CGPoint { get set }

    var vertex3: CGPoint { get set }
}

extension Triangular {
    public func contains(point: CGPoint) -> Bool {
        false
    }

    public func overlaps(with circle: Circular) -> Bool {
        false
    }

    public func overlaps(with triangle: Triangular) -> Bool {
        false
    }
}
