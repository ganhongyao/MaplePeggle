//
//  GameBucketView.swift
//  PeggleClone
//
//  Created by Hong Yao on 24/2/22.
//

import SwiftUI

struct GameBucketView: View {
    @StateObject var gameBucketViewModel: GameBucketViewModel

    var body: some View {
        Image(ViewConstants.bucketImage)
            .resizable()
            .frame(width: gameBucketViewModel.bucketWidth, height: gameBucketViewModel.bucketHeight)
            .position(gameBucketViewModel.bucketPosition)
            .animation(.easeInOut, value: gameBucketViewModel.bucketWidth)
    }
}
