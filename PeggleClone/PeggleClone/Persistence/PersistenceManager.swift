//
//  PersistenceManager.swift
//  PeggleClone
//
//  Created by Hong Yao on 30/1/22.
//

import Foundation

protocol PersistenceManager {
    func fetchAll<T: Persistable>(sortDescriptors: [NSSortDescriptor]) -> [T]

    func fetchWithId<T: Persistable>(id: UUID) -> T?

    func save<T: Persistable>(model: T)

    func delete<T: Persistable>(model: T)
}
