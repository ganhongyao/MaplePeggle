//
//  ViewsUtil.swift
//  PeggleClone
//
//  Created by Hong Yao on 20/1/22.
//

import SwiftUI

func getPegImage(color: Peg.Color) -> Image {
    Image("peg-\(color.rawValue)")
}

func getPegImage(color: Peg.Color, isLit: Bool) -> Image {
    guard isLit else {
        return Image("peg-\(color.rawValue)")
    }

    return Image("peg-\(color.rawValue)-glow")
}

func getGameBackgroundImage(chosenGameMaster: GameMaster?) -> Image {
    guard let chosenGameMaster = chosenGameMaster else {
        return Image(ViewConstants.fountainBackgroundImage)
    }

    switch chosenGameMaster {
    case .archer:
        return Image(ViewConstants.henesysBackgroundImage)
    case .magician:
        return Image(ViewConstants.elliniaBackgroundImage)
    case .thief:
        return Image(ViewConstants.kerningBackgroundImage)
    case .warrior:
        return Image(ViewConstants.perionBackgroundImage)
    default:
        return Image(ViewConstants.fountainBackgroundImage)
    }
}

func getGameMusicToPlay(chosenGameMaster: GameMaster?) -> Sound {
    guard let chosenGameMaster = chosenGameMaster else {
        return .restNPeace
    }

    switch chosenGameMaster {
    case .archer:
        return .restNPeace
    case .magician:
        return .whenTheMorningComes
    case .thief:
        return .badGuys
    case .warrior:
        return .nightmare
    default:
        return .restNPeace
    }
}

func makeSnapshotImage(snapshotImageData: Data?) -> Image {
    guard let snapshotImageData = snapshotImageData,
          let uiImage = UIImage(data: snapshotImageData) else {
              return Image(systemName: ViewConstants.boardCardDefaultImage)
          }

    return Image(uiImage: uiImage)
}
