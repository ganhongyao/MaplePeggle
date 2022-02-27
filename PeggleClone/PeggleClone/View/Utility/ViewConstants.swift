//
//  ViewConstants.swift
//  PeggleClone
//
//  Created by Hong Yao on 13/2/22.
//

import SwiftUI

struct ViewConstants {
    /// Image asset names
    static let coralBackgroundImage = "coral"
    static let titleBackgroundImage = "title"
    static let fountainBackgroundImage = "fountain"
    static let henesysBackgroundImage = "henesys"
    static let athenaPierceImage = "athena-pierce"
    static let kerningBackgroundImage = "kerning"
    static let darkLordImage = "dark-lord"
    static let elliniaBackgroundImage = "ellinia"
    static let grendelTheReallyOldImage = "grendel-the-really-old"
    static let perionBackgroundImage = "perion"
    static let dancesWithBalrogImage = "dances-with-balrog"
    static let deleteImage = "delete"
    static let cannonImage = "cannon"
    static let ballImage = "ball"
    static let bucketImage = "portal"

    static let backgroundBlurRadius = 3.0

    /// Audio
    static let audioFadeDuration = 10.0
    static let gameMusicFadeDuration = 4.0

    /// MainMenuView
    static let mainMenuNavTitle = "Main Menu"
    static let mainMenuCreateLevelText = "Create New Level"
    static let mainMenuLoadLevelText = "Load Existing Level"

    /// LevelSelectorView
    static let levelSelectorNavTitle = "Levels"
    static let levelSelectorRowSpacing = 10.0
    static let levelSelectorColumnSpacing = 10.0
    static let levelSelectorNumColumns = 3
    static let levelSelectorCreateButtonText = "Design New Level"
    static let levelSelectorCreateButtonImage = "plus.circle"
    static let levelSelectorPlayButtonText = "PLAY"
    static let levelSelectorPlayButtonImage = "play.fill"

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
    static let levelDesignerNavTitle = "Design Level"
    static let levelDesignerPegSelectorHeightRatio = 0.1
    static let levelDesignerScrollAmount = 50.0
    static let levelDesignerSelectionColor = Color.orange

    /// LevelDesignerBoardView
    static let levelDesignerBoardSelectionStrokeWidth = 5.0
    static let levelDesignerBoardSelectionStrokeDash = 5.0

    /// PegSelectorView
    static let pegSelectorScrollUpImage = "arrow.up.circle.fill"
    static let pegSelectorScrollDownImage = "arrow.down.circle.fill"
    static let pegSelectorMultiselectImage = "cursorarrow.and.square.on.square.dashed"

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
    static let gameControlsScoreLabel = "Score"

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
