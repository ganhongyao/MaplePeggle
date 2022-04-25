//
//  GameBlockView.swift
//  MaplePeggle
//
//  Created by Hong Yao on 22/2/22.
//

import SwiftUI

struct GameBlockView: View {
    @ObservedObject var gameBlockViewModel: GameBlockViewModel

    let yOffset: CGFloat

    private var verticesWithOffset: [CGPoint] {
        gameBlockViewModel.vertices.map { $0.offset(y: yOffset) }
    }

    private var shape: Path {
        Path { path in
            path.addLines(verticesWithOffset)
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
