//
//  LevelDesignerViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 19/1/22.
//

import Foundation
import CoreGraphics
import SwiftUI

class LevelDesignerViewModel: ObservableObject {
    @Published var isShowingError = false

    @Published var error: PersistenceError?

    private(set) var pegSelectorViewModel = PegSelectorViewModel()

    private(set) var controlsViewModel: ControlsViewModel?

    private(set) var boardViewModel: LevelDesignerBoardViewModel?

    private let boardId: UUID?

    init(boardId: UUID? = nil) {
        self.boardId = boardId
        controlsViewModel = ControlsViewModel(levelDesignerViewModel: self)
        boardViewModel = LevelDesignerBoardViewModel(boardId: boardId, levelDesignerViewModel: self)

        assert(controlsViewModel != nil)
        assert(boardViewModel != nil)
    }

    var boardSize: CGSize {
        boardViewModel?.boardSize ?? .zero
    }

    func unselectBoardObject() -> BoardObject? {
        let selectedObject = boardViewModel?.selectedObject
        boardViewModel?.select(object: nil)
        return selectedObject
    }

    func reselectBoardObject(selectedObject: BoardObject?) {
        boardViewModel?.select(object: selectedObject)
    }

    func saveBoard() {
        guard let controlsViewModel = controlsViewModel,
              let boardViewModel = boardViewModel else {
            return
        }

        if controlsViewModel.levelName.isEmpty {
            controlsViewModel.levelName = Board.defaultBoardNameIfEmpty
        }

        do {
            try CoreDataManager.sharedInstance.save(model: boardViewModel.board)
        } catch let persistenceError as PersistenceError {
            isShowingError = true
            error = persistenceError
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    func setBoardSnapshot(snapshotImage: UIImage) {
        boardViewModel?.setSnapshot(snapshotImage: snapshotImage)
    }
}
