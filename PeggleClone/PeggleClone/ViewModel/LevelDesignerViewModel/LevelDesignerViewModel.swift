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

    private(set) var pegSelectorViewModel: PegSelectorViewModel?

    private(set) var controlsViewModel: ControlsViewModel?

    @Published private(set) var boardViewModel: LevelDesignerBoardViewModel?

    private let boardId: UUID?

    init(boardId: UUID? = nil) {
        self.boardId = boardId
        controlsViewModel = ControlsViewModel(levelDesignerViewModel: self)
        boardViewModel = LevelDesignerBoardViewModel(boardId: boardId, levelDesignerViewModel: self)
        pegSelectorViewModel = PegSelectorViewModel(levelDesignerViewModel: self)
    }

    var boardSize: CGSize {
        boardViewModel?.boardSize ?? .zero
    }

    func unselectBoardObjects() -> [BoardObject] {
        guard let boardViewModel = boardViewModel else {
            return []
        }

        let selectedObjects = boardViewModel.selectedObjects
        boardViewModel.selectedObjects = []
        return selectedObjects
    }

    func reselectBoardObjects(selectedObjects: [BoardObject]) {
        boardViewModel?.selectedObjects = selectedObjects
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
