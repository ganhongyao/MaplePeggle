//
//  Peg.swift
//  MaplePeggle
//
//  Created by Hong Yao on 18/1/22.
//

import Foundation
import CoreGraphics
import PhysicsEngine

class Peg: Circular, BoardObject {
    enum Color: String, CaseIterable {
        case blue
        case orange
        case green
        case purple
    }

    static let defaultRadius: CGFloat = 25

    let id: UUID?

    var center: CGPoint

    var radius: CGFloat

    var facingAngle: CGFloat = .zero

    let color: Peg.Color

    var isPowerup: Bool {
        color == .green
    }

    required init(center: CGPoint, radius: CGFloat, color: Peg.Color,
                  id: UUID? = UUID(), facingAngle: CGFloat = .zero) {
        self.id = id
        self.center = center
        self.radius = radius
        self.facingAngle = facingAngle
        self.color = color
    }

    convenience init(from pegToClone: Peg, newCenter: CGPoint? = nil, newRadius: CGFloat? = nil,
                     newColor: Peg.Color? = nil) {
        self.init(center: newCenter ?? pegToClone.center, radius: newRadius ?? pegToClone.radius,
                  color: newColor ?? pegToClone.color, id: pegToClone.id)
    }

    func rotate(angle: CGFloat) {
        facingAngle += angle
    }
}

extension Peg: CustomStringConvertible {
    var description: String {
        "Peg: { id: \(String(describing: id)), center: \(center), radius: \(radius), color: \(color) }"
    }
}

// MARK: Hashable
extension Peg: Hashable {
    static func == (lhs: Peg, rhs: Peg) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: Persistable
extension Peg: Persistable {
    /// Deserializes a PegEntity object managed by Core Data to a Peg instance
    static func fromManagedObject(_ managedObject: PegEntity) -> Self {
        Self(center: CGPoint(x: managedObject.centerX, y: managedObject.centerY),
             radius: managedObject.radius,
             color: intRepresentationToColor(intRep: managedObject.color),
             id: managedObject.id,
             facingAngle: managedObject.facingAngle
        )
    }

    /// Serializes a PegEntity object which is managed by Core Data.
    func toManagedObject() -> PegEntity {
        let entity = CoreDataManager.sharedInstance.makeCoreDataEntity(class: Peg.self)
        entity.id = id
        entity.centerX = center.x
        entity.centerY = center.y
        entity.radius = radius
        entity.facingAngle = facingAngle
        entity.color = Peg.colorToIntRepresentation(color: color)

        return entity
    }

    private static func colorToIntRepresentation(color: Peg.Color) -> Int64 {
        guard let intRep = Peg.Color.allCases.firstIndex(of: color) else {
            assertionFailure("Color is expected to be an element of allCases, but is not")
            return -1
        }
        return Int64(intRep)
    }

    private static func intRepresentationToColor(intRep: Int64) -> Peg.Color {
        guard intRep >= 0 && intRep < Peg.Color.allCases.count else {
            return .blue
        }

        return Peg.Color.allCases[Int(intRep)]
    }
}
