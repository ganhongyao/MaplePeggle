//
//  Block.swift
//  PeggleClone
//
//  Created by Hong Yao on 21/2/22.
//

import Foundation
import CoreGraphics
import PhysicsEngine

class Block: Polygonal, BoardObject {
    private static let defaultLength = 50.0

    let id: UUID?

    var vertices: [CGPoint] = []

    required init(id: UUID? = UUID(), vertices: [CGPoint]) {
        self.id = id
        self.vertices = vertices
    }

    convenience init(center: CGPoint) {
        let vertex1 = CGPoint(x: center.x, y: center.y - Block.defaultLength * sqrt(3) / 3)
        let vertex2 = CGPoint(x: center.x + Block.defaultLength / 2, y: center.y + Block.defaultLength * sqrt(3) / 6)
        let vertex3 = CGPoint(x: center.x - Block.defaultLength / 2, y: center.y + Block.defaultLength * sqrt(3) / 6)

        self.init(vertices: [vertex1, vertex2, vertex3])
    }

    convenience init(from blockToClone: Block) {
        self.init(id: blockToClone.id, vertices: blockToClone.vertices)
    }
}

extension Block: Hashable {
    static func == (lhs: Block, rhs: Block) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: Persistable
extension Block: Persistable {
    static func fromManagedObject(_ managedObject: BlockEntity) -> Self {
        let vertex1 = CGPoint(x: managedObject.vertex1X, y: managedObject.vertex1Y)
        let vertex2 = CGPoint(x: managedObject.vertex2X, y: managedObject.vertex2Y)
        let vertex3 = CGPoint(x: managedObject.vertex3X, y: managedObject.vertex3Y)

        return Self(id: managedObject.id, vertices: [vertex1, vertex2, vertex3])
    }

    func toManagedObject() -> BlockEntity {
        let entity = CoreDataManager.sharedInstance.makeCoreDataEntity(class: Block.self)
        entity.id = id

        entity.vertex1X = vertices[0].x
        entity.vertex1Y = vertices[0].y

        entity.vertex2X = vertices[1].x
        entity.vertex2Y = vertices[1].y

        entity.vertex3X = vertices[2].x
        entity.vertex3Y = vertices[2].y

        return entity
    }

}
