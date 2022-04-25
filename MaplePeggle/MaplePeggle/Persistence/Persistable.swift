//
//  Persistable.swift
//  MaplePeggle
//
//  Created by Hong Yao on 24/1/22.
//

import Foundation
import CoreData

protocol Persistable: Identifiable {
    associatedtype ManagedObject: NSManagedObject

    var id: UUID? { get }

    static func fromManagedObject(_ managedObject: ManagedObject) -> Self

    @discardableResult func toManagedObject() -> ManagedObject
}
