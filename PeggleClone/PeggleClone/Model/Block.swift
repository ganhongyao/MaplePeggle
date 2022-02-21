//
//  Block.swift
//  PeggleClone
//
//  Created by Hong Yao on 21/2/22.
//

import Foundation
import CoreGraphics
import PhysicsEngine

class Block: Triangular {
    private static let defaultLength = 50.0

    let id: UUID?

    var vertex1: CGPoint

    var vertex2: CGPoint

    var vertex3: CGPoint

    required init(id: UUID? = UUID(), vertex1: CGPoint, vertex2: CGPoint, vertex3: CGPoint) {
        self.id = id
        self.vertex1 = vertex1
        self.vertex2 = vertex2
        self.vertex3 = vertex3
    }

    convenience init(center: CGPoint) {
        let vertex1 = CGPoint(x: center.x, y: center.y - Block.defaultLength * sqrt(3) / 3)
        let vertex2 = CGPoint(x: center.x + Block.defaultLength / 2, y: center.y + Block.defaultLength * sqrt(3) / 6)
        let vertex3 = CGPoint(x: center.x - Block.defaultLength / 2, y: center.y + Block.defaultLength * sqrt(3) / 6)

        self.init(vertex1: vertex1, vertex2: vertex2, vertex3: vertex3)
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
        Self(id: managedObject.id,
             vertex1: CGPoint(x: managedObject.vertex1X, y: managedObject.vertex1Y),
             vertex2: CGPoint(x: managedObject.vertex2X, y: managedObject.vertex2Y),
             vertex3: CGPoint(x: managedObject.vertex3X, y: managedObject.vertex3Y))
    }

    func toManagedObject() -> BlockEntity {
        let entity = CoreDataManager.sharedInstance.makeCoreDataEntity(class: Block.self)
        entity.id = id

        entity.vertex1X = vertex1.x
        entity.vertex1Y = vertex1.y

        entity.vertex2X = vertex2.x
        entity.vertex2Y = vertex2.y

        entity.vertex3X = vertex3.x
        entity.vertex3Y = vertex3.y

        return entity
    }

}
