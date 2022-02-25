//
//  PersistenceManager.swift
//  PeggleClone
//
//  Created by Hong Yao on 30/1/22.
//

import Foundation

protocol PersistenceManager {
    func fetchAll<T: Persistable>(sortDescriptors: [NSSortDescriptor]) throws -> [T]

    func fetchWithId<T: Persistable>(id: UUID) throws -> T?

    func save<T: Persistable>(model: T) throws

    func delete<T: Persistable>(model: T) throws
}
