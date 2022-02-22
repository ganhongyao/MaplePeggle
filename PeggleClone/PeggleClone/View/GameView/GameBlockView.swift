//
//  GameBlockView.swift
//  PeggleClone
//
//  Created by Hong Yao on 22/2/22.
//

import SwiftUI

struct GameBlockView: View {
    @ObservedObject var gameBlockViewModel: GameBlockViewModel

    private var shape: Path {
        Path { path in
            path.addLines(gameBlockViewModel.vertices)
            path.closeSubpath()
        }
    }

    var body: some View {
        ZStack {
            shape.fill(.brown)
            shape.stroke(.black, lineWidth: ViewConstants.blockOutlineLineWidth)
        }
    }
}
