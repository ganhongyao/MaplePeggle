//
//  Triangular.swift
//  
//
//  Created by Hong Yao on 21/2/22.
//

import CoreGraphics

public protocol Triangular: Polygonal {

}

extension Triangular {
    public var edges: [(CGPoint, CGPoint)] {
        [(vertices[0], vertices[1]),
         (vertices[1], vertices[2]),
         (vertices[2], vertices[0])]
    }

    public var edgeVectors: [CGVector] {
        edges.map({ pointA, pointB in
            CGVector(from: pointB).subtract(CGVector(from: pointA))
        })
    }

    public func contains(point: CGPoint) -> Bool {
        false
    }

    public func overlaps(with circle: Circular) -> Bool {
        circle.overlaps(with: self)
    }

    public func overlaps(with triangle: Triangular) -> Bool {
        return overlaps(otherPolygon: triangle)
    }

}
