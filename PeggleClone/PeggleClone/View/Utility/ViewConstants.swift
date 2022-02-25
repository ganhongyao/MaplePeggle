//
//  ViewConstants.swift
//  PeggleClone
//
//  Created by Hong Yao on 13/2/22.
//

struct ViewConstants {
    // TODO: Remove
    static let loremIpsum = """
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do \
                            eiusmod tempor incididunt ut labore et dolore magna aliqua. Lectus \
                            vestibulum mattis ullamcorper velit sed ullamcorper morbi.
                            """
    /// Image asset names
    static let coralBackgroundImage = "coral"
    static let deleteImage = "delete"
    static let cannonImage = "cannon"
    static let ballImage = "ball"
    static let bucketImage = "bucket"

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
    static let pegEditingCircleFractionOfDiameter = 0.2

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
    static let gameWonDialogTitle = "Level Cleared"
    static let gameLostDialogTitle = "Game Over"
    static let gameReturnButtonText = "Return to Level Designer"
    static let gameRestartDialogButtonText = "Restart"
    static let gameControlsHeightRatio = 0.05

    /// GameMasterSelectorView
    static let gameMasterSelectorTitle = "Choose Your Character"
    static let gameMasterDialogCornerRadius = 20.0
    static let gameMasterDialogShadowRadius = 10.0
    static let gameMasterImageCornerRadius = 10.0
    static let gameMasterImageSize = 100.0
    static let gameMasterDialogSize = 500.0

    /// GameControlsView
    static let gameQuitButtonText = "Leave Game"
    static let gameQuitButtonImage = "escape"
    static let gameRestartButtonText = "Restart Level"
    static let gameRestartButtonImage = "arrow.uturn.forward.circle"
    static let gameBallThresholdForWarning = 3

    /// GameBoardView
    static let gameBoardCannonAnimationDuration = 1.0
    static let gameBoardObjectScaleOnRemoval = 1.1
    static let gameBoardObjectAnimationDuration = 1.0
    static let gameBallPreferredPlacement = 0.33

    /// GameCannonView
    static let cannonAimCancelImage = "xmark.circle"
    static let cannonAimCancelOpacity = 0.3
    static let cannonPadding = 5.0
    static let cannonHeightRatio = 0.1

    /// GameBucketView
    static let bucketHeightRatio = 0.1
}
