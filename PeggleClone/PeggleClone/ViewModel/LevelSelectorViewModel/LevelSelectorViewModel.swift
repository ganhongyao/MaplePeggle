//
//  LevelSelectorViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 25/1/22.
//

import Foundation

class LevelSelectorViewModel: ObservableObject {
    private static let sortDescriptorKey = "name"

    @Published var boards: [Board] = []

    @Published var isShowingError = false

    @Published var error: PersistenceError?

    func fetchAllBoards() {
        let sortDescriptors = [NSSortDescriptor(key: LevelSelectorViewModel.sortDescriptorKey, ascending: true)]

        if !CoreDataManager.sharedInstance.isSeeded {
            do {
                try SeedData.seedAllBoards(database: CoreDataManager.sharedInstance)
            } catch {
                print("Error seeding boards: \(error)")
            }
        }

        do {
            let fetchedBoards: [Board] = try CoreDataManager.sharedInstance.fetchAll(sortDescriptors: sortDescriptors)
            boards = fetchedBoards
        } catch let persistenceError as PersistenceError {
            isShowingError = true
            error = persistenceError
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}
