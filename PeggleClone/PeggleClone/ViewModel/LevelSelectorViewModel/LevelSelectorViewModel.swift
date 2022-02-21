//
//  LevelSelectorViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 25/1/22.
//

import Foundation

class LevelSelectorViewModel: ObservableObject {
    @Published var boards: [Board] = []

    @Published var isShowingError = false

    @Published var error: PersistenceError?

    func fetchAllBoards() {
        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

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