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
    public var vertices: [CGPoint] {
        [vertex1, vertex2, vertex3]
    }

    public var edges: [(CGPoint, CGPoint)] {
        [(vertex1, vertex2),
         (vertex2, vertex3),
         (vertex1, vertex3)]
    }

    public func contains(point: CGPoint) -> Bool {
        false
    }

    public func overlaps(with circle: Circular) -> Bool {
        circle.overlaps(with: self)
    }

    public func overlaps(with triangle: Triangular) -> Bool {
        false
    }
}
