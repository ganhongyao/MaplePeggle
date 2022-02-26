//
//  GameBucketViewModel.swift
//  PeggleClone
//
//  Created by Hong Yao on 24/2/22.
//

import Foundation
import CoreGraphics

class GameBucketViewModel: ObservableObject {
    @Published private var gameBucket: GameBucket

    var bucketWidth: CGFloat {
        gameBucket.width
    }

    var bucketHeight: CGFloat {
        get {
            gameBucket.height
        }

        set {
            gameBucket.height = newValue

            objectWillChange.send()
        }

    }

    var bucketPosition: CGPoint {
        get {
            gameBucket.center
        }

        set {
            gameBucket.initialPosition = newValue

            objectWillChange.send()
        }
    }

    init(gameBucket: GameBucket) {
        self.gameBucket = gameBucket
    }
}
