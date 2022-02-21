//
//  TriangularObject.swift
//  
//
//  Created by Hong Yao on 21/2/22.
//

import CoreGraphics

public protocol TriangularObject {
    var vertex1: CGPoint { get set }

    var vertex2: CGPoint { get set }

    var vertex3: CGPoint { get set }
}

extension TriangularObject {
    public func contains(point: CGPoint) -> Bool {
        false
    }

    public func overlaps(with otherCircle: CircularObject) -> Bool {
        false
    }
}
