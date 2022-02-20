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

func makeSnapshotImage(snapshotImageData: Data?) -> Image {
    guard let snapshotImageData = snapshotImageData,
          let uiImage = UIImage(data: snapshotImageData) else {
              return Image(systemName: ViewConstants.boardCardDefaultImage)
          }

    return Image(uiImage: uiImage)
}
