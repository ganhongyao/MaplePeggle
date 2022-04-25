//
//  GenericPolygon.swift
//  MaplePeggle
//
//  Created by Hong Yao on 27/2/22.
//

import CoreGraphics
import PhysicsEngine

class GenericPolygon: Polygonal {
    var vertices: [CGPoint]

    init(vertices: [CGPoint]) {
        self.vertices = vertices
    }

    convenience init(from rect: CGRect) {
        let origin = rect.origin
        let vertices = [origin,
                        CGPoint(x: origin.x + rect.width, y: origin.y),
                        CGPoint(x: origin.x + rect.width, y: origin.y + rect.height),
                        CGPoint(x: origin.x, y: origin.y + rect.height)]

        self.init(vertices: vertices)
    }
}
