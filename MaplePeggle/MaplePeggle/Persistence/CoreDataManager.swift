//
//  CoreDataManager.swift
//  MaplePeggle
//
//  Created by Hong Yao on 24/1/22.
//

import Foundation
import CoreData

class CoreDataManager: PersistenceManager {
    static let sharedInstance = CoreDataManager()

    private let container: NSPersistentContainer

    private static let containerName = "MaplePeggle"

    private static let isSeededKey = "isSeeded"

    var isSeeded: Bool {
        let defaults = UserDefaults.standard

        guard defaults.string(forKey: CoreDataManager.isSeededKey) == nil else {
            return true
        }

        defaults.set(true, forKey: CoreDataManager.isSeededKey)
        return false
    }

    private init() {
        container = NSPersistentContainer(name: CoreDataManager.containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
    }

    private static func entityName<T: Persistable>(ofClass class: T.Type) -> String {
        String(describing: T.ManagedObject.self)
    }

    private static func makeFetchRequest<T: Persistable>(forClass classArg: T.Type) -> NSFetchRequest<T.ManagedObject> {
        let entityName = entityName(ofClass: classArg)

        return NSFetchRequest(entityName: entityName)
    }

    func makeCoreDataEntity<T: Persistable>(class: T.Type) -> T.ManagedObject {
        T.ManagedObject(context: container.viewContext)
    }

    func fetchAll<T: Persistable>(sortDescriptors: [NSSortDescriptor] = []) throws -> [T] {
        let fetchRequest = CoreDataManager.makeFetchRequest(forClass: T.self)
        fetchRequest.sortDescriptors = sortDescriptors

        let fetchedEntities: [T.ManagedObject]

        do {
            fetchedEntities = try container.viewContext.fetch(fetchRequest)
        } catch {
            throw PersistenceError(className: CoreDataManager.entityName(ofClass: T.self), failedOperation: .fetch)
        }

        return fetchedEntities.map(T.fromManagedObject)
    }

    func fetchWithId<T: Persistable>(id: UUID) throws -> T? {
        let fetchRequest = CoreDataManager.makeFetchRequest(forClass: T.self)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)

        let fetchedEntities: [T.ManagedObject]

        do {
            fetchedEntities = try container.viewContext.fetch(fetchRequest)
        } catch {
            throw PersistenceError(className: CoreDataManager.entityName(ofClass: T.self), failedOperation: .fetch)
        }

        guard let fetchedEntity = fetchedEntities.first else {
            return nil
        }

        return T.fromManagedObject(fetchedEntity)
    }

    func save<T: Persistable>(model: T) throws {
        do {
            if let modelId = model.id,
               let _: T = try fetchWithId(id: modelId) {
                try delete(model: model)
            }

            // In Core Data, initialising an NSManagedObject will save it into Core Data on calling .save()
            model.toManagedObject()

            return try container.viewContext.save()
        } catch {
            throw PersistenceError(className: CoreDataManager.entityName(ofClass: T.self), failedOperation: .save)
        }

    }

    func delete<T: Persistable>(model: T) throws {
        guard let modelId = model.id else {
            return
        }

        do {
            let fetchRequest = CoreDataManager.makeFetchRequest(forClass: T.self)
            fetchRequest.predicate = NSPredicate(format: "id == %@", modelId.uuidString)

            let fetchedEntities = try container.viewContext.fetch(fetchRequest)

            guard let fetchedEntity = fetchedEntities.first else {
                return
            }

            container.viewContext.delete(fetchedEntity)

            return try container.viewContext.save()
        } catch {
            throw PersistenceError(className: CoreDataManager.entityName(ofClass: T.self), failedOperation: .delete)
        }
    }
}
