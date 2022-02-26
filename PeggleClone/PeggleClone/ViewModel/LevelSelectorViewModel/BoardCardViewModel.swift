//
//  BoardCardViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 28/1/22.
//

import Foundation

class BoardCardViewModel: ObservableObject {
    private static let seedDeletionErrorMessage = "Preloaded levels cannot be deleted."

    @Published var isShowingError = false

    @Published var error: PersistenceError?

    private var board: Board

    private let levelSelectorViewModel: LevelSelectorViewModel

    init(board: Board, levelSelectorViewModel: LevelSelectorViewModel) {
        self.board = board
        self.levelSelectorViewModel = levelSelectorViewModel
    }

    var gameViewModel: GameViewModel {
        GameViewModel(board: board)
    }

    var boardId: UUID? {
        board.id
    }

    var name: String {
        board.name
    }

    var caption: String {
        guard let dateCreated = board.dateCreated else {
            return ""
        }

        guard !board.isSeedData else {
            return "Preloaded Level"
        }

        let currentDateTime = Date()
        let distanceFromCreation = RelativeDateTimeFormatter().localizedString(for: dateCreated, relativeTo: currentDateTime)

        return "Created \(distanceFromCreation)"
    }

    var snapshotImageData: Data? {
        board.snapshot
    }

    func deleteBoard() {
        // TODO: Uncomment
//        guard !board.isSeedData else {
//            isShowingError = true
//            error = PersistenceError(className: String(describing: Board.self),
//                                     failedOperation: .delete,
//                                     reason: BoardCardViewModel.seedDeletionErrorMessage)
//            return
//        }

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
