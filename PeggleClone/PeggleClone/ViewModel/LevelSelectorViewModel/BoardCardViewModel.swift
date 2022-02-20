//
//  BoardCardViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 28/1/22.
//

import Foundation

class BoardCardViewModel: ObservableObject {
    @Published var isShowingError = false

    @Published var error: PersistenceError?

    private var board: Board

    private let levelSelectorViewModel: LevelSelectorViewModel

    init(board: Board, levelSelectorViewModel: LevelSelectorViewModel) {
        self.board = board
        self.levelSelectorViewModel = levelSelectorViewModel
    }

    var boardId: UUID? {
        board.id
    }

    var name: String {
        board.name
    }

    var dateTimeSinceCreated: String {
        guard let dateCreated = board.dateCreated else {
            return ""
        }

        let currentDateTime = Date()
        return RelativeDateTimeFormatter().localizedString(for: dateCreated, relativeTo: currentDateTime)
    }

    var snapshotImageData: Data? {
        board.snapshot
    }

    func deleteBoard() {
        do {
            try CoreDataManager.sharedInstance.delete(model: board)
        } catch let persistenceError as PersistenceError {
            isShowingError = true
            error = persistenceError
        } catch {
            print("Unexpected error: \(error)")
        }

        levelSelectorViewModel.fetchAllBoards()
    }
}
