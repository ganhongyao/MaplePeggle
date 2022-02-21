//
//  ViewConstants.swift
//  PeggleClone
//
//  Created by Hong Yao on 13/2/22.
//

struct ViewConstants {
    /// Image asset names
    static let coralBackgroundImage = "coral"
    static let deleteImage = "delete"
    static let cannonImage = "cannon"
    static let ballImage = "ball"

    /// LevelSelectorView
    static let levelSelectorNavTitle = "Levels"
    static let levelSelectorRowSpacing = 20.0
    static let levelSelectorColumnSpacing = 30.0
    static let levelSelectorItemsPerRow = 3
    static let levelSelectorCreateButtonText = "Create New Level"
    static let levelSelectorCreateButtonImage = "plus.circle"

    /// BoardCardView
    static let boardCardLineLimit = 1
    static let boardCardTextScaleFactor = 0.5
    static let boardCardDefaultImage = "photo"
    static let boardCardEditButtonImage = "pencil.circle"
    static let boardCardDeleteButtonImage = "trash.circle"
    static let boardCardIconButtonSize = 20.0
    static let boardCardCornerRadius = 10.0
    static let boardCardShadowRadius = 5.0

    /// LevelDesignerView
    static let levelDesignerPegSelectorHeightRatio = 0.1

    /// PegView
    static let pegNumTapsToSelect = 2

    /// BlockView
    static let blockOutlineLineWidth = 3.0
    static let blockVertexCircleDiameter = 12.0

    /// ControlsView
    static let controlsStartButtonText = "START"
    static let controlsLoadButtonText = "LOAD"
    static let controlsSaveButtonText = "SAVE"
    static let controlsResetButtonText = "RESET"
    static let controlsTextFieldLabel = "Level Name"

    /// GameView
    static let gameCompletedDialogTitle = "Level Completed"
    static let gameReturnButtonText = "Return to Level Designer"
    static let gameRestartDialogButtonText = "Restart"

    /// GameControlsView
    static let gameQuitButtonText = "Leave Game"
    static let gameQuitButtonImage = "escape"
    static let gameRestartButtonText = "Restart Level"
    static let gameRestartButtonImage = "arrow.uturn.forward.circle"

    /// GameBoardView
    static let gameBoardCannonAnimationDuration = 1.0
    static let gameBoardPegScaleOnRemoval = 1.1
    static let gameBoardPegAnimationDuration = 1.0

    /// GameCannonView
    static let cannonAimCancelImage = "xmark.circle"
    static let cannonAimCancelOpacity = 0.3
    static let cannonPadding = 5.0
}
